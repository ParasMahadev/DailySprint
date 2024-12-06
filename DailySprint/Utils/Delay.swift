//
//  Delay.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation

// MARK: - Delay
// Class to perform delayed work with a cancel option
class Delay {
    
    private var seconds: Double // Time delay in seconds
    
    // MARK: - Initializer
    init(_ seconds: Double = 2) {
        self.seconds = seconds
    }
    
    var workItem: DispatchWorkItem? // Holds the work item for cancellation
    
    // MARK: - Functions
    
    // Perform work after a delay
    func performWork(_ work: @escaping () -> Void) {
        // Create the work item to execute
        workItem = DispatchWorkItem(block: {
            work()
        })
        // Execute work after the specified delay
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem!)
    }
    
    // Cancel the scheduled work if needed
    func cancel() {
        workItem?.cancel()
    }
}
