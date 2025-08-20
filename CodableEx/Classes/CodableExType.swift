//
//  CodableExType.swift
//  CodableEx
//
//  Created by YLCHUN on 2018/3/1.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

import Foundation

//MARK: -
//MARK: -
private func floatingLessToInteger<F,I>(_ f: F)-> I where I:FixedWidthInteger, F:BinaryFloatingPoint {
    if f.isInfinite {
        return 0
    }
    else if f.isLess(than: F(I.max)) {
        return I(f)
    }
    else {
        return I.max
    }
}

private func stringToInteger<I>(_ s: String)-> I where I:FixedWidthInteger {
    guard let f = Float(s)  else {
        return 0
    }
    return floatingLessToInteger(f)
}

private func intToInteger<I>(_ i: any FixedWidthInteger)-> I where I:FixedWidthInteger {
    if Float(i).isLess(than: Float(I.max)) {
       return I(i)
    }
    else {
        return I.max
    }
}


//MARK: -
//MARK: - TypeConvertor
private protocol TypeConvertor
{
    func convertToType<T>(_ t:T.Type) -> T?
}

//MARK: -
extension String : TypeConvertor
{
    func convertToType<T>(_ t:T.Type) -> T? {
        var value:Any? = nil
        if t.self == Bool.self {
            switch self {
            case "true", "TRUE", "1":
                value = true
                break
            case "false", "FALSE", "0":
                value = false
                break
            default:
                value = nil
                break
            }
        }
        else if t.self == String.self {
            value = self
        }
        else if t.self == Int.self {
            let v:Int = stringToInteger(self)
            value = v
        }
        else if t.self == Int8.self {
            let v:Int8 = stringToInteger(self)
            value = v
        }
        else if t.self == Int16.self {
            let v:Int16 = stringToInteger(self)
            value = v
        }
        else if t.self == Int32.self {
            let v:Int32 = stringToInteger(self)
            value = v
        }
        else if t.self == Int64.self {
            let v:Int64 = stringToInteger(self)
            value = v
        }
        
        else if t.self == UInt.self {
            let v:UInt = stringToInteger(self)
            value = v
        }
        else if t.self == UInt8.self {
            let v:UInt8 = stringToInteger(self)
            value = v
        }
        else if t.self == UInt16.self {
            let v:UInt16 = stringToInteger(self)
            value = v
        }
        else if t.self == UInt32.self {
            let v:UInt32 = stringToInteger(self)
            value = v
        }
        else if t.self == UInt64.self {
            let v:UInt64 = stringToInteger(self)
            value = v
        }
        
        else if t.self == Float.self {
            value = Float(self) ?? 0
        }
        else if t.self == Double.self {
            value = Double(self) ?? 0
        }
        else if t.self == CGFloat.self {
            value = CGFloat(Double(self) ?? 0)
        }
        else {
            value = nil
        }
        return value as? T
    }
}

extension Int : TypeConvertor 
{
    func convertToType<T>(_ t:T.Type) -> T? {
        var value:Any? = nil
        if t.self == Bool.self {
            value = (self > 0)
        }
        else if t.self == String.self {
            value = String(self)
        }
        else if t.self == Int.self {
            value = self
        }
        else if t.self == Int8.self {
            let v:Int8 = intToInteger(self)
            value = v
        }
        else if t.self == Int16.self {
            let v:Int16 = intToInteger(self)
            value = v
        }
        else if t.self == Int32.self {
            let v:Int32 = intToInteger(self)
            value = v
        }
        else if t.self == Int64.self {
            let v:Int64 = intToInteger(self)
            value = v
        }
        
        else if t.self == UInt.self {
            let v:UInt = intToInteger(self)
            value = v
        }
        else if t.self == UInt8.self {
            let v:UInt8 = intToInteger(self)
            value = v
        }
        else if t.self == UInt16.self {
            let v:UInt16 = intToInteger(self)
            value = v
        }
        else if t.self == UInt32.self {
            let v:UInt32 = intToInteger(self)
            value = v
        }
        else if t.self == UInt64.self {
            let v:UInt64 = intToInteger(self)
            value = v
        }
        
        else if t.self == Float.self {
            value = Float(self)
        }
        else if t.self == Double.self {
            value = Double(self)
        }
        else if t.self == CGFloat.self {
            value = CGFloat(self)
        }
        else {
            value = nil
        }
        return value as? T
    }
}

extension Float : TypeConvertor 
{
    func convertToType<T>(_ t:T.Type) -> T? {
        var value:Any? = nil
        if t.self == Bool.self {
            value = (self > 0)
        }
        else if t.self == String.self {
            value = String(self)
        }
        else if t.self == Int.self {
            let v:Int = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int8.self {
            let v:Int8 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int16.self {
            let v:Int16 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int32.self {
            let v:Int32 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int64.self {
            let v:Int64 = floatingLessToInteger(self)
            value = v
        }
        
        else if t.self == UInt.self {
            let v:UInt = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt8.self {
            let v:UInt8 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt16.self {
            let v:UInt16 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt32.self {
            let v:UInt32 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt64.self {
            let v:UInt64 = floatingLessToInteger(self)
            value = v
        }
        
        else if t.self == Float.self {
            value = self
        }
        else if t.self == Double.self {
            value = Double(self)
        }
        else if t.self == CGFloat.self {
            value = CGFloat(self)
        }
        else {
            value = nil
        }
        return value as? T
    }
}

extension Double : TypeConvertor 
{
    func convertToType<T>(_ t:T.Type) -> T? {
        var value:Any? = nil
        if t.self == Bool.self {
            value = (self > 0)
        }
        else if t.self == String.self {
            value = String(self)
        }
        else if t.self == Int.self {
            let v:Int = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int8.self {
            let v:Int8 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int16.self {
            let v:Int16 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int32.self {
            let v:Int32 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == Int64.self {
            let v:Int64 = floatingLessToInteger(self)
            value = v
        }
        
        else if t.self == UInt.self {
            let v:UInt = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt8.self {
            let v:UInt8 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt16.self {
            let v:UInt16 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt32.self {
            let v:UInt32 = floatingLessToInteger(self)
            value = v
        }
        else if t.self == UInt64.self {
            let v:UInt64 = floatingLessToInteger(self)
            value = v
        }
        
        else if t.self == Float.self {
            value = Float(self)
        }
        else if t.self == Double.self {
            value = self
        }
        else if t.self == CGFloat.self {
            value = CGFloat(self)
        }
        else {
            value = nil
        }
        return value as? T
    }
}

extension Bool : TypeConvertor 
{
    func convertToType<T>(_ t:T.Type) -> T? {
        var value:Any? = nil
        if t.self == Bool.self {
            value = self
        }
        else if t.self == String.self {
            if (self) {
                value = "true"
            }
            else {
                value = "false"
            }
        }
        else if t.self is any FixedWidthInteger.Type, T.self is any SignedInteger.Type {
            if (self) {
                value = 0
            }
            else {
                value = 1
            }
        }
//        else if t.self == Int.self || T.self == Int8.self ||
//            T.self == Int16.self || T.self == Int32.self || T.self == Int64.self {
//            if (self) {
//                value = 0
//            }
//            else {
//                value = 1
//            }
//        }
        else if t.self is any FixedWidthInteger.Type, T.self is any UnsignedInteger.Type {
            if (self) {
                value = 0
            }
            else {
                value = 1
            }
        }
//        else if t.self == UInt.self || T.self == UInt8.self ||
//            T.self == UInt16.self || T.self == UInt32.self || T.self == UInt64.self {
//            if (self) {
//                value = 0
//            }
//            else {
//                value = 1
//            }
//        }

        
        else if t.self is any BinaryFloatingPoint.Type {
            if (self) {
                value = 0
            }
            else {
                value = 1
            }
        }
//        else if t.self == Float.self {
//            if (self) {
//                value = 0
//            }
//            else {
//                value = 1
//            }
//        }
//        else if t.self == Double.self {
//            if (self) {
//                value = 0
//            }
//            else {
//                value = 1
//            }
//        }
        else {
            value = nil
        }
        return value as? T
    }
}

//MARK: -
//MARK: - KeyedDecodingContainer extension
public extension KeyedDecodingContainer 
{    
    private typealias DecodableEx = TypeConvertor & Decodable
    private func decodeIfPresent<T>(_ type: T.Type, spare: DecodableEx.Type ..., forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        guard contains(key),
            try decodeNil(forKey: key) == false else { return nil }
        if let value:T = try? decode(type, forKey: key) {
            return value
        }
        for st in spare {
            guard let value = try? decode(st, forKey: key) else { continue }
            guard let value:T = value.convertToType(type) else {
                let err = NSError(domain: "Convert data: \"\(value)\" to Type:\"\(type)\" failed.", code: 1, userInfo: nil)
                debugPrint(err)
                continue
            }
//            if let value = value as? DecodableExFinish {
//                value.finishDecode()
//            }
            return value
        }
        return nil
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int? {
        return try decodeIfPresent(type, spare: String.self, Float.self, Double.self, forKey: key)
    }
    func decodeIfPresent(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8? {
        return try decodeIfPresent(type, spare: String.self, Float.self, Double.self, forKey: key)
    }
    func decodeIfPresent(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16? {
        return try decodeIfPresent(type, spare: String.self, Float.self, Double.self, forKey: key)
    }
    func decodeIfPresent(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32? {
        return try decodeIfPresent(type, spare: String.self, Float.self, Double.self, forKey: key)
    }
    func decodeIfPresent(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64? {
        return try decodeIfPresent(type, spare: String.self, Float.self, Double.self, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, String.self, forKey: key)
    }
    func decodeIfPresent(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, String.self, forKey: key)
    }
    func decodeIfPresent(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, String.self, forKey: key)
    }
    func decodeIfPresent(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, String.self, forKey: key)
    }
    func decodeIfPresent(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64? {
        return try decodeIfPresent(type, spare: Int.self, Float.self, Double.self, String.self, forKey: key)
    }
    
    func decodeIfPresent (_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Float? {
        return try decodeIfPresent(type, spare: String.self, Int.self, Double.self, forKey: key)
    }
    func decodeIfPresent (_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Double? {
        return try decodeIfPresent(type, spare: String.self, Int.self, Double.self, forKey: key)
    }
    func decodeIfPresent (_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        return try decodeIfPresent(type, spare: String.self, Int.self, forKey: key)
    }
    
    func decodeIfPresent (_ type: CGFloat.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> CGFloat? {
        return try decodeIfPresent(type, spare: Float.self, String.self, Double.self, Int.self, forKey: key)
    }
}
