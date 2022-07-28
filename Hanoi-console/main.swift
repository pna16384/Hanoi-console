//
//  main.swift
//  Hanoi-console
//
//  Created by Paul Angel on 28/07/2022.
//

// Swift version of C++ and Kotlin versions developed in 2018

import Foundation

typealias Char = Character

class Hanoi {
    
    // The tower T is represented by an implicit group of cylinders C = < ci : (0 <= i < n); size(ci) > size(ci+1) (for all i>=0)> (so cylinder sizes decrease as we iterate through the array)
    // Each entry in T T[i] corresponds to cylinder ci and stores it's peg location only.  All cylinders are initialised to start on peg A, where pegs are labelled <A, B, C>.
    
    var T : [Char]
    
    var n : Int { T.count }
    
    static let pegs : Set<Char> = ["A", "B", "C"]
    
    init(withNumCylinders numCylinders : Int) {
        
        T = [Char](repeating: "A", count: numCylinders)
        
        // Note: numCylinders not stored explicitly as T.count represnets the number of cylinders on the tower - this is implemented as computed property 'n'
    }
    
    func printCurrentState() {
        
        print(T)
    }
    
    // Solve the Tower of Hanoi recursively, where i is the current cylinder index to move, target is the peg to move the cylinder to and move is the current count of moves made so far.  Note: move = 0 is only defaulted in the first call into solve (not from any recursive call)
    func solve(_ i:Int, _ target:Char, _ move:Int = 0) -> Int {
        
        var currentMove = move
        
        // Drill down through each cylinder (each cylinder is considered the base of it's own sub-tower).  Alternate the target peg each recursive step through the tower so we move sub-towers correctly onto other pegs without violating the rules of the Tower of Hanoi
        if (i < n - 1) {
            
            // Note: This version uses Swift set difference (subtracting) given {A, B, C} \ {T[i], target} - return the peg that is not in the set {T[i], target}.  Note: Force unwrap since there is always going to be one disjoint element from the peg set {A, B, C}
            currentMove = solve(i + 1, Hanoi.pegs.subtracting(Set([T[i], target])).first!, currentMove)
        }
        
        // Move current cylinder 'i' to peg 'target' and increment move counter
        T[i] = target
        currentMove+=1
        
        // Print the current state after the move is complete
        print("Currnet move: \(currentMove)")
        printCurrentState()
        
        // Once a cylinder has moved to 'target', recursively move all 'sub-tower' cylinders on top of this target to enforce Tower of Hanoi rules
        if (i < n - 1) {
            
            currentMove = solve(i + 1, target, currentMove)
        }
        
        // Once a sub-tower is complete, return the number of moves taken
        return currentMove
    }
}


// Create hanoi tower
var hanoi = Hanoi(withNumCylinders: 4)

// Print initial state
print("Initial state = ")
hanoi.printCurrentState()

// Initiate solve starting from bottom cylinder (i=0) and move this to target peg "C" from initial peg "A" (see Hanoi class notes)
let totalMoves = hanoi.solve(0, "C")

// Print final state
print("Final state = ")
hanoi.printCurrentState()

// Verify number of moves is optimal
if totalMoves ==  (0x01 << hanoi.n) - 1 {
    
    print("Total moves = \(totalMoves).  This is optimal!")
}
