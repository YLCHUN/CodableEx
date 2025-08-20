//
//  CodableExBox.swift
//  CodableEx
//
//  Created by Cityu on 2024/5/6.
//

import Foundation


private typealias CodableExBoxCodingKey = CodableExBox<Any>.RawCodingKey

public struct CodableExBox<T>: Codable 
{
    public var raw: T
    
    fileprivate struct RawCodingKey: CodingKey {
       var stringValue: String
       var intValue: Int?

       init?(stringValue: String) {
           self.stringValue = stringValue
       }

       init?(intValue: Int) {
           self.intValue = intValue
           self.stringValue = String(intValue)
       }
    }
    
    fileprivate static var rawType: T.Type {
        return T.self
    }
    
    fileprivate init(_ raw: T) {
        self.raw = raw
    }
    
    public init(from decoder: Decoder) throws {
        if T.self is Decodable.Type {
            let container = try decoder.singleValueContainer()
            raw = try container.decode((T.self as! Decodable.Type)) as! T
        }
        else if T.self is [String:Any].Type {
            let container = try decoder.container(keyedBy: CodableExBoxCodingKey.self)
            raw = try container.decode([String:Any].self) as! T
        }
        else if T.self is [Any].Type {
            var container = try decoder.unkeyedContainer()
            raw = try container.decode([Any].self) as! T
        }
        else {
            throw NSError(domain: "CodableExBox decode \"\(T.self)\" failed.", code: 1, userInfo: nil)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if T.self is Encodable.Type {
            var container = encoder.singleValueContainer()
            try container.encode((raw as! Encodable))
        }
        else if T.self is [String:Any].Type {
            var container = encoder.container(keyedBy: CodableExBoxCodingKey.self)
            try container.encode(raw as! [String:Any])
        }
        else if T.self is [Any].Type {
            var container = encoder.unkeyedContainer()
            try container.encode(raw as! [Any])
        }
        else {
            throw NSError(domain: "CodableExBox encode \"\(T.self)\" failed.", code: 1, userInfo: nil)
        }
    }
}

private extension KeyedDecodingContainer where Key == CodableExBoxCodingKey {
    func decode(_ type: [String: Any].Type)throws -> [String:Any]  {
        var dict = [String:Any]()
        for key in allKeys {
            if try decodeNil(forKey: key) {
                dict[key.stringValue] = NSNull()
            } 
            else if let val = try? decode(Int.self, forKey: key) {
                dict[key.stringValue] = val
            } 
            else if let val = try? decode(Int64.self, forKey: key) {
                dict[key.stringValue] = val
            } 
            else if let val = try? decode(Bool.self, forKey: key) {
                dict[key.stringValue] = val
            } 
            else if let val = try? decode(Float.self, forKey: key) {
                dict[key.stringValue] = val
            }
            else if let val = try? decode(Double.self, forKey: key) {
                dict[key.stringValue] = val
            } 
            else if let val = try? decode(String.self, forKey: key) {
                dict[key.stringValue] = val
            } 
            else if let container = try? nestedContainer(keyedBy: CodableExBoxCodingKey.self, forKey: key), let val = try? container.decode([String: Any].self) {
                dict[key.stringValue] = val
            } 
            else if var container = try? nestedUnkeyedContainer(forKey: key), let val = try? container.decode([Any].self) {
                dict[key.stringValue] = val
            }
            else {
                debugPrint("CodableExBox decode failed for key:", key.stringValue)
            }
        }
        return dict
    }
}

private extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var arr: [Any] = []
        while !isAtEnd {
            if try decodeNil() {
                arr.append(NSNull())
            }
            else if let val = try? decode(Int.self) {
                arr.append(val)
            }
            else if let val = try? decode(Int64.self) {
                arr.append(val)
            }
            else if let val = try? decode(Bool.self) {
                arr.append(val)
            }
            else if let val = try? decode(Float.self) {
                arr.append(val)
            }
            else if let val = try? decode(Double.self) {
                arr.append(val)
            }
            else if let val = try? decode(String.self) {
                arr.append(val)
            }
            else if let container = try? nestedContainer(keyedBy: CodableExBoxCodingKey.self), let val = try? container.decode([String: Any].self) {
                arr.append(val)
            }
            else if var container = try? nestedUnkeyedContainer(), let val = try? container.decode([Any].self) {
                arr.append(val)
            }
            else {
                debugPrint("CodableExBox decode failed")
            }
        }
        return arr
    }
}

private extension KeyedEncodingContainer where K == CodableExBoxCodingKey {
    mutating func encode(_ value: [String: Any]) throws {
        for (k, v) in value {
            let key = CodableExBoxCodingKey(stringValue: k)!
            switch v {
            case is NSNull:
                try encodeNil(forKey: key)
            case let val as Int:
                try encode(val, forKey: key)
            case let val as Int64:
                try encode(val, forKey: key)
            case let val as Bool:
                try encode(val, forKey: key)
            case let val as Float:
                try encode(val, forKey: key)
            case let val as Double:
                try encode(val, forKey: key)
            case let val as String:
                try encode(val, forKey: key)
            case let val as [String: Any]:
                var container = nestedContainer(keyedBy: CodableExBoxCodingKey.self, forKey: key)
                try container.encode(val)
            case let val as [Any]:
                var container = nestedUnkeyedContainer(forKey: key)
                try container.encode(val)
            default:
                debugPrint("CodableExBox encode failed for type:", v)
                continue
            }
        }
    }
}

private extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        for v in value {
            switch v {
            case is NSNull:
                try encodeNil()
            case let val as Int:
                try encode(val)
            case let val as Int64:
                try encode(val)
            case let val as Bool:
                try encode(val)
            case let val as Float:
                try encode(val)
            case let val as Double:
                try encode(val)
            case let val as String:
                try encode(val)
            case let val as [String: Any]:
                var container = self.nestedContainer(keyedBy: CodableExBoxCodingKey.self)
                try container.encode(val)
            case let val as [Any]:
                var container = nestedUnkeyedContainer()
                try container.encode(val)
            default:
                debugPrint("CodableExBox encode failed for type:", v)
            }
        }
    }
}
