//
//  TaskRepository.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    // MARK: - Singleton Instance
    // Shared instance to access CoreDataProvider
    static let shared = CoreDataProvider()
    
    // MARK: - Persistent Container
    // Core Data persistent container that manages the model, context, and persistent store
    let persistentContainer: NSPersistentContainer
    
    // MARK: - View Context
    // The main context used for interacting with Core Data
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initializer
    // Private initializer to ensure the singleton instance is used
    private init() {
        
        // Register custom value transformer for UIColor conversion
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: NSValueTransformerName("UIColorTransformer"))
        
        // Initialize the persistent container with the "DailySprint" model
        persistentContainer = NSPersistentContainer(name: "DailySprint")
        
        // Load persistent stores, handling errors if necessary
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Error initializing RemindersModel \(error)")
            }
        }
    }
}
