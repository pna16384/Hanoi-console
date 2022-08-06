//
//  main.swift
//  Hanoi-console
//
//  Created by Paul Angel on 28/07/2022.
//

// Swift version of C++ and Kotlin versions developed in 2018.  Modified version of initial commit - this version uses bitwise flags for peg labelling.  This allows bitwise ops to select next peg rather than Set selection of character labelled pegs

import Foundation



class Hanoi {
    
    // The tower T is represented by an ordered array of cylinders wherw T = < ci : (0 <= i < n); ci.size > (ci+1).size (for all i>=0)> (so cylinder sizes decrease as we iterate through the array).  Each entry T[i] corresponds to cylinder ci and stores it's peg location along with its colour and pre-computed size.  Pegs are bit encoded as 0b100, 0b010 and 0b001, with all cylinders starting on peg 0b001.
    
    var T : [Cylinder] = []
    var n : Int { T.count } // n is a computed property returning the number of cylinders
    
    init(withColours cylinderColours:[xterm256Colour]) {
        
        for i in 0..<cylinderColours.count {
            
            T.append(Cylinder(peg: 0b100, size: 1 + ((cylinderColours.count-i) << 1), colour: cylinderColours[i]))
        }
    }
    
    /*
    func printCurrentState() { // depricated
        
        print("[", terminator:"")
        
        for i in 0..<n {
            
            switch T[i].peg {
            
            case 0b001:
                print("\(xterm256Colour.Red.rawValue)", terminator:"")
            case 0b010:
                print("\(xterm256Colour.Green.rawValue)", terminator:"")
            case 0b100:
                print("\(xterm256Colour.Yellow.rawValue)", terminator:"")
            default:
                print("\(xterm256Colour.Default.rawValue)", terminator:"")
            }
            
            print("\(T[i].size)\(xterm256Colour.Default.rawValue)", terminator: (i < n - 1) ? ", " : "")
        }
        
        print("]")
    }
    */
    
    func printTower() {
        
        // "ascii-art" version of tower configuration
        
        /*
         
         Render peg board...
         
         largest cylinder width = 1 + (T.count << 1) = w
         g = gap between largest cylinder if 2 copies on neighbouring pegs
         
      ^                 |             |             |
      |                 |             |             |
     n+1                |             |             |
      v   ((w-1)/2)+1   |    w        |      w      |  ((w-1)/2)+1
         ----------------------------------------------------------
         
         */
        
        let w : Int = 1 + (T.count << 1)
        
        // build peg row string
        let pegRow = String(repeating:" ", count:((w - 1) >> 1) + 1) + "|" + String(repeating:" ", count:w) + "|" + String(repeating:" ", count:w) + "|" + String(repeating:" ", count:((w - 1) >> 1) + 1)
        
        // draw peg rows and base line
        for _ in 0...T.count {
            
            print(pegRow)
        }
        print(String(repeating:"\u{25AC}", count:3 * w + 4))
        
        
        // Dictionary to track number of cylinders rendered on each peg
        
        struct Peg {
            
            let offset : Int // x character offset for rendering
            var count : Int // count of number of cylinders rendered into peg board
        }
        
        var pegs : [UInt8 : Peg] = [
            0b100 : Peg(offset:((w - 1) >> 1) + 1, count:0),
            0b010 : Peg(offset:((w - 1) >> 1) + w + 2, count:0),
            0b001 : Peg(offset:((w - 1) >> 1) + (w << 1) + 3, count:0)]
        
        for cylinder in T {
            
            let x : Int = pegs[cylinder.peg]!.offset - ((cylinder.size-1)>>1)
            var printString : String = ""
            
            // position cursor
            printString += String(repeating:"\u{001B}[A", count:pegs[cylinder.peg]!.count + 2) // y offset
            printString += String(repeating:"\u{001B}[C", count:x) // x offset
            
            // setup colour
            printString += cylinder.colour.rawValue
            
            // setup cylinder
            printString += String(repeating:"\u{25A0}", count:cylinder.size)
            
            // reset colour and cursor position
            printString += xterm256Colour.Default.rawValue
            printString += String(repeating:"\u{001B}[B", count:pegs[cylinder.peg]!.count + 2) // reset y to base
            printString += String(repeating:"\u{001B}[D", count:cylinder.size + x) // reset to start of line
            
            // draw
            print(printString, terminator: "")
            
            // Update pegs count
            pegs[cylinder.peg]?.count += 1
        }
    }
    
    
    // Solve the Tower of Hanoi recursively, where i is the current cylinder index to move, target is the peg to move the cylinder to and move is the current count of moves made so far.  Note: move = 0 is only defaulted in the first call into solve (not from any recursive call)
    func solve(_ i:Int, _ target:UInt8, _ move:Int = 0) -> Int {
        
        var currentMove = move
        
        // Drill down through each cylinder (each cylinder is considered the base of it's own sub-tower).  Alternate the target peg each recursive step through the tower so we move sub-towers correctly onto other pegs without violating the rules of the Tower of Hanoi
        if (i < n - 1) {
           
            currentMove = solve(i + 1,  ~(T[i].peg | target) & 0b111, currentMove)
        }
        
        // Move current cylinder 'i' to peg 'target' and increment move counter
        T[i].peg = target
        currentMove += 1
        
        // Print the current state after the move is complete
        print("Currnet move: \(currentMove)")
        //printCurrentState()
        printTower()
        
        // Once a cylinder has moved to 'target', recursively move all 'sub-tower' cylinders on top of this target to enforce Tower of Hanoi rules
        if (i < n - 1) {
            
            currentMove = solve(i + 1, target, currentMove)
        }
        
        // Once a sub-tower is complete, return the number of moves taken
        return currentMove
    }
}



// Create hanoi tower (number implicit in size of colour array) - cylinder size implicit in position in T array
var hanoi = Hanoi(withColours:[.Red, .Green, .Yellow, .Magenta, .Cyan])

// Print initial state
print("Initial state =")
//hanoi.printCurrentState()
hanoi.printTower()

// Initiate solve starting from bottom cylinder (i=0) and move this to target peg 0b001 from initial peg 0b100
let totalMoves = hanoi.solve(0, 0b001)

// Print final state
print("Final state = ")
//hanoi.printCurrentState()
hanoi.printTower()

// Verify number of moves is optimal
if totalMoves ==  (0x01 << hanoi.n) - 1 {
    
    print("Total moves = \(totalMoves).  This is optimal!")
}

