//
//  Colour.swift
//  Hanoi-console
//
//  Created by Paul Angel on 04/08/2022.
//

import Foundation

// xterm256 escape sequences to colour-code cylinder peg positions (see https://en.wikipedia.org/wiki/ANSI_escape_code for more complete list as well as console input / cursor control sequences)
enum xterm256Colour : String {
    
    case Default = "\u{001B}[0m"
    case Red = "\u{001B}[38;5;9m"
    case Green = "\u{001B}[38;5;10m"
    case Yellow = "\u{001B}[38;5;11m"
}

