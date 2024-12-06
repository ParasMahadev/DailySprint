//
//  Persistence.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//

import CoreData

struct PersistenceController {
    
    // MARK: - Singleton Instance
    // A shared instance of the PersistenceController for global access.
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    // MARK: - Initializer
    // Initializes the NSPersistentContainer and optionally sets up an in-memory store for testing or temporary data.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DailySprint")
        
        // Set the URL for in-memory store if inMemory is true (useful for testing)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load the persistent stores and handle any potential errors.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)") // Terminate if an error occurs.
            }
        })
        
        // Enable automatic merging of changes from parent contexts.
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
