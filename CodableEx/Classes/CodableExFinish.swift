//
//  CodableEx.swift
//  CodableEx
//
//  Created by YLCHUN on 2018/3/1.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

import Foundation

//MARK: -
//MARK: - CodableExFinish
public typealias CodableExFinish = DecodableExFinish & EncodableExFinish

public protocol DecodableExFinish
{
    func finishEncode() -> Void
}
public protocol EncodableExFinish
{
    func finishEncode() -> Void
}


extension DecodableExFinish
{
    func finishDecode() -> Void {}
}
extension EncodableExFinish
{
    func finishEncode() -> Void {}
}

public extension KeyedDecodingContainer
{
    func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedEncodingContainer<K>.Key) throws -> T? where T: DecodableExFinish, T: Decodable {
        guard contains(key),
            try decodeNil(forKey: key) == false else { return nil }
        let val = try? decode(type, forKey: key)
        val?.finishDecode()
        return val
    }
}

public extension KeyedEncodingContainer {
    mutating func encodeIfPresent<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key) throws where T: EncodableExFinish, T: Encodable  {
        if let value = value {
            var container = nestedUnkeyedContainer(forKey: key)
            try container.encode(value)
            value.finishEncode()
        } 
        else {
            try encodeNil(forKey: key)
        }
    }
}
