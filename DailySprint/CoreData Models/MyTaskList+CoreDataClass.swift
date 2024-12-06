//
//  MyTaskList+CoreDataClass.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//
//

import Foundation
import CoreData

@objc(MyTaskList)
public class MyTaskList: NSManagedObject {
    
    // get the reminders that are not completed
    lazy var remindersByMyListRequest: NSFetchRequest<Reminders> = {
        let request = Reminders.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "list = %@ AND isCompleted = false", self)
        return request
    }()
}
