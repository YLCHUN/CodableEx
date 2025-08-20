//
//  ViewController.swift
//  CodableEx
//
//  Created by YLCHUN on 2018/3/2.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

import UIKit
import CodableEx

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        codableEx()
    }
    
    func codableEx()
    {
        let dict : [String:Any] = ["nums":1, "numi":"1.1", "flag_f":"A", "mt":1 , "models":[["num":11, "flag":"A"]], "dict":["1":1,"arr":[1,2,3]], "arr":[["num":11, "flag":"A"]],"model":["num":11, "flag":"A"]]
        let arr : Array<[String:Any]> = [
            ["nums":"1", "numi":"1", "flag_f":"A", "mt":0 , "models":[["num":"11", "flag":"A"]], "dict":["1":1]],
            ["nums":"2", "numi":"1", "flag_f":"A", "mt":1 , "models":[["num":"21", "flag":"B"]], "dict":["1":1]]
        ]
        
        let model   : CodableModel?         = try? dict.decode()
        let models  : [CodableModel]?       = try? arr.decode()
        do {
            let model   : CodableModel         = try dict.decode()
            let models  : [CodableModel]       = try arr.decode()
            
            let json    : [String:Any]  = try model.encode()
            let jsons    : Array<[String:Any]>  = try models.encode()

            let json2    : String               = try CodableEx().encode(model)
            let jsons2   : String               = try CodableEx().encode(models)
            print(json, json2, jsons, jsons2)
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
}
