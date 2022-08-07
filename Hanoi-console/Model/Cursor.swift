//
//  Cursor.swift
//  Hanoi-console
//
//  Created by Paul Angel on 07/08/2022.
//

import Foundation

// Cursor encapsulates xterm cursor movement / placement strings
struct Cursor {
    
    static func up(_ n:Int) -> String {
        
        String(repeating:"\u{001B}[A", count:n)
    }
    
    static func down(_ n:Int) -> String {
        
        String(repeating:"\u{001B}[B", count:n)
    }
    
    static func right(_ n:Int) -> String {
        
        String(repeating:"\u{001B}[C", count:n)
    }
    
    static func left(_ n:Int) -> String {
        
        String(repeating:"\u{001B}[D", count:n)
    }
}
