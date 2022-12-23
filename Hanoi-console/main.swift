//
//  main.swift
//  Hanoi-console
//
//  Created by Paul Angel on 28/07/2022.
//

// Swift version of C++ and Kotlin versions developed in 2018
// Modified with knowledge that cylinders alternate direction of movement, so next peg is derivable from cylinder index.
import Foundation

typealias Char = Character

class Hanoi {
    
    // The tower T is represented by an implicit group of cylinders C = < ci : (0 <= i < n); size(ci) > size(ci+1) (for all i>=0)> (so cylinder sizes decrease as we iterate through the array)
    // Each entry in T T[i] corresponds to cylinder ci and stores it's peg location only.  All cylinders are initialised to start on peg 2, where pegs are labelled <2, 1, 0>.
    
    var T : [Int32]
    var n : Int { T.count }
        
    init(withNumCylinders numCylinders : Int) {
        
        T = [Int32](repeating: 2, count: numCylinders)
        
        // Note: numCylinders not stored explicitly as T.count represnets the number of cylinders on the tower - this is implemented as computed property 'n'
    }
    
    func printCurrentState() {
        
        print(T)
    }
    
    // More compact solve that does not rely on peg set model, using only index of cylinder (in cyinder array P[]) to calculate move (uising n cylinders, where i=0 is the bottom (largest) cylinder
    func solve(_ i:Int = 0, _ move:Int = 0) -> Int
    {
        var currentMove = move
        
        if (i<n)
        {
            currentMove = solve(i + 1, currentMove);

            T[i] = ((i & 0b1) == 0) ? (T[i] + 1) % 3 : min((T[i] - 1) & 0b11, 2);
            currentMove += 1;
            printCurrentState()
            
            currentMove = solve(i + 1, currentMove);
        }
        
        return currentMove;
    }
}



// Create hanoi tower
var hanoi = Hanoi(withNumCylinders: 3)

// Print initial state
print("Initial state = ")
hanoi.printCurrentState()

// Initiate solve starting from bottom cylinder (i=0 default parameter) and move this to target peg 0 from initial peg 2 (see Hanoi class notes above)
let totalMoves = hanoi.solve()

// Print final state
print("Final state = ")
hanoi.printCurrentState()

// Verify number of moves is optimal
if totalMoves ==  (0x01 << hanoi.n) - 1 {
    
    print("Total moves = \(totalMoves).  This is optimal!")
}
