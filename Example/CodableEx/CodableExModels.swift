//
//  CodableExModels.swift
//  CodableExTests
//
//  Created by YLCHUN on 2018/3/5.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

import Foundation
import CodableEx

public class CodableModel2 : Codable
{
    var num : Int?
    var flag : String?
}

public enum ModelType: Int, Codable
{
    case TA
    case TB
}


public class CodableModel : Codable
{
    var nums : String?
    var numi : CGFloat?
    var flag : String?
    var dict : CodableExBox<[String:Any]>?
    var arr : CodableExBox<[Any]>?
    var models : Array<CodableModel2>?
    var model : CodableModel2?
    var mt : ModelType?
    
    enum CodingKeys : String, CodingKey
    {
        case dict
        case arr
        case nums
        case numi
        case flag = "flag_f"
        case models
        case model
        case mt
    }
}


extension CodableModel2 : CodableExFinish 
{
    public func finishEncode() ->Void {
        print("finishEncode\(self)")
    }
    
    public func finishDecode() ->Void {
        print("finishDecode\(self)")
    }
}
//
//extension CodableModel : CodableExFinish
//{
//    public func finishEncode() ->Void {
//        print("finishEncode\(self)")
//    }
//    
//    public func finishDecode() ->Void {
//        print("finishDecode\(self)")
//    }
//}
