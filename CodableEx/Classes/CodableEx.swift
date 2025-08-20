//
//  CodableEx.swift
//  CodableEx
//
//  Created by YLCHUN on 2018/3/1.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

import Foundation

extension Encodable {
    public func encode() throws -> [String:Any] {
        return try CodableEx().encode(self)
    }
}

//MARK: -
//MARK: - Dictionary & Array extension
extension Array where Element:Encodable
{
    public func encode() throws -> Array<[String:Any]> {
        return try CodableEx().encode(self)
    }
}

extension Array where Element == [String:Any]
{
    public func decode<T:Decodable>() throws -> Array<T> {
        return try CodableEx().decode(self)
    }
}

extension Dictionary where Key == String
{
    public func decode<T:Decodable>() throws -> T {
        return try CodableEx().decode(self)
    }
}


//MARK: -
//MARK: - CodableEx
public final class CodableEx
{
    public init() {
        
    }

    fileprivate func jsonStr2JsonObj<T>(_ jsonStr:String) throws -> T {
        guard let data = jsonStr.data(using: .utf8)
            else { throw NSError(domain: "Convert \"\(jsonStr)\" to Data data failed.", code: 1, userInfo: nil) }
        let jsonObj = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
        guard let obj = jsonObj as? T
            else { throw NSError(domain: "Convert \"\(jsonStr)\" to \(T.self) data failed.", code: 2, userInfo: nil) }
        return obj
    }
    
    fileprivate func jsonObj2Data<T>(_ jsonObj:T) throws -> Data {
        return try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
    }
    
    fileprivate func jsonObj2Model<T, RT:Decodable>(_ any:T) throws -> RT {
        let data = try jsonObj2Data(any)
        let any = try JSONDecoder().decode(RT.self, from: data)
        return any
    }
    
    fileprivate func model2Data<T:Encodable>(_ any:T) throws -> Data {
        return try JSONEncoder().encode(any)
    }
    
    fileprivate func model2JsonObj<T:Encodable, RT>(_ any:T) throws -> RT {
        let data = try model2Data(any)
        let res = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
        guard let rt = res as? RT
            else { throw NSError(domain: "Convert \"\(any)\" to jsonObject failed.", code: 3, userInfo: nil) }
        return rt
    }
    
    //MARK: public
    public func decode<T:Decodable>(_ dict:[String:Any]) throws -> T {
        return try jsonObj2Model(dict)
    }
    
    public func decode<T:Decodable>(_ arr:Array<[String:Any]>) throws -> Array<T> {
        return try jsonObj2Model(arr)
    }

    public func encode<T:Encodable>(_ model:T) throws -> [String:Any] {
        return try model2JsonObj(model)
    }
    
    public func encode<T:Encodable>(_ models:Array<T>) throws -> Array<[String:Any]> {
        return try model2JsonObj(models)
    }
}

extension CodableEx
{
    public func decode<T:Decodable>(_ json:String) throws -> T {
        let dict:[String:Any] = try jsonStr2JsonObj(json)
        return try decode(dict)
    }
    
    public func decode<T:Decodable>(_ json:String) throws -> Array<T> {
        let arr:[[String:Any]] = try jsonStr2JsonObj(json)
        return try decode(arr)
    }
    
    public func encode<T:Encodable>(_ model:T) throws -> String {
        let data = try model2Data(model)
        guard let ret = String(data: data, encoding: .utf8)
            else { throw NSError(domain: "Convert \"\(model)\" to String data failed.", code: 4, userInfo: nil) }
        return ret
    }
    
    public func encode<T:Encodable>(_ models:Array<T>) throws -> String {
        let data = try model2Data(models)
        guard let ret = String(data: data, encoding: .utf8)
            else { throw NSError(domain: "Convert \"\(models)\" to String data failed.", code: 4, userInfo: nil) }
        return ret
    }
}


