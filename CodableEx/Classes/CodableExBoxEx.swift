//
//  CodableExBoxEx.swift
//  CodableEx
//
//  Created by Cityu on 2024/5/7.
//

import Foundation

extension CodableExBox where T == [String:Any] {
    public var count: Int {
        return raw.count
    }
    
    public subscript(key: String) -> Any? {
        set {
            raw[key] = newValue
        }
        get {
            return raw[key]
        }
    }
    
    public subscript(key: String, default defaultValue: @autoclosure () -> Any) -> Any {
        set {
            raw[key] = newValue
        }
        get {
            return raw[key] ?? defaultValue()
        }
    }
}

extension CodableExBox where T == [Any] {
    public var count: Int {
        return raw.count
    }
    
    public subscript(index: Int) -> Any {
        set {
            raw[index] = newValue
        }
        get {
            return raw[index]
        }
    }
    
    public subscript(bounds: Range<Int>) -> ArraySlice<Any> {
        set {
            raw[bounds] = newValue
        }
        get {
            return raw[bounds]
        }
    }
}
