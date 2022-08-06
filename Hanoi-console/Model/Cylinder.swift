//
//  Cylinder.swift
//  Hanoi-console
//
//  Created by Paul Angel on 04/08/2022.
//

import Foundation

/*
@propertyWrapper struct OddInt {
 
    var wrappedValue : Int {
        didSet { wrappedValue = wrappedValue | 0x01 }
    }
    
    init(wrappedValue : Int) {
        
        self.wrappedValue  = wrappedValue | 0x01
    }
}
*/

struct Cylinder {
    
    var peg : UInt8
    let size : Int
    let colour : xterm256Colour
}
