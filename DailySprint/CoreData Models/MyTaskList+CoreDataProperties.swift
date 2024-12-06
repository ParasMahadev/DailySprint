//
//  MyTaskList+CoreDataProperties.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//
//

import Foundation
import CoreData
import UIKit

extension MyTaskList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyTaskList> {
        return NSFetchRequest<MyTaskList>(entityName: "MyTaskList")
    }

    @NSManaged public var name: String
    @NSManaged public var color: UIColor

}

extension MyTaskList : Identifiable {

}

// MARK: Generated accessors for notes
extension MyTaskList {

    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: Reminders)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromReminders(_ value: Reminders)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ values: NSSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ values: NSSet)
}
