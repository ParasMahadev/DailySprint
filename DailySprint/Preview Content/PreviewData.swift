//
//  PreviewData.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation
import CoreData

class PreviewData {
    
    // MARK: - Reminder Preview Data
    // Fetches the first reminder from Core Data or creates a new one if none exists
    static var reminder: Reminders {
        let viewContext = CoreDataProvider.shared.viewContext
        let request = Reminders.fetchRequest()
        return (try? viewContext.fetch(request).first) ?? Reminders(context: viewContext)
    }
    
    // MARK: - MyTaskList Preview Data
    // Fetches the first MyTaskList from Core Data or creates a new one if none exists
    static var myTask: MyTaskList {
        let context = CoreDataProvider.shared.persistentContainer.viewContext
        let request = MyTaskList.fetchRequest()
        return(try? context.fetch(request).first) ?? MyTaskList()
    }
}
