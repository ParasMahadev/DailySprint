//
//  Untitled.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation
import CoreData
import UIKit

class DatabseServices {
    
    // MARK: - View Context
    // Provides the Core Data context for interacting with data
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.viewContext
    }
    
    // MARK: - Save Data
    // Saves changes to the viewContext
    static func save() throws {
        try viewContext.save()
    }
    
    // MARK: - Notification Scheduling
    // Schedules a local notification for the reminder
    static private func scheduleNotification(reminder: Reminders) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title ?? ""
        content.body = reminder.notes ?? ""
        
        // Prepare date components based on the reminder's date and time
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.reminderDate ?? Date())
        
        if let reminderTime = reminder.reminderTime {
            let reminderTimeDateComponents = reminderTime.dateComponents
            dateComponents.hour = reminderTimeDateComponents.hour
            dateComponents.minute = reminderTimeDateComponents.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "Reminder Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Update Reminder
    // Updates a reminder's details and schedules a notification if necessary
    static func updateReminder(reminder: Reminders, editConfig: ReminderEditConfig) throws {
        let reminderToUpdate = reminder
        reminderToUpdate.isCompleted = editConfig.isCompleted
        reminderToUpdate.title = editConfig.title
        reminderToUpdate.notes = editConfig.notes
        reminderToUpdate.reminderDate = editConfig.hasDate ? editConfig.reminderDate : nil
        reminderToUpdate.reminderTime = editConfig.hasTime ? editConfig.reminderTime : nil
        
        try save()
        
        // Schedule a notification if the reminder has a date or time
        if editConfig.hasDate || editConfig.hasTime {
            scheduleNotification(reminder: reminder)
        }
    }
    
    // MARK: - Delete Reminder
    // Deletes the specified reminder from Core Data
    static func deleteReminder(reminder: Reminders) throws {
        viewContext.delete(reminder)
        try save()
    }
    
    // MARK: - Save My Task List
    // Creates and saves a new task list with the provided name and color
    static func saveMyList(_ name: String, _ color: UIColor) throws {
        let myList = MyTaskList(context: viewContext)
        myList.name = name
        myList.color = color
        try save()
    }
    
    // MARK: - Save Reminder to My List
    // Saves a new reminder under a specific task list
    static func saveReminderToMyList(myList: MyTaskList, reminderTitle: String) throws {
        let reminder = Reminders(context: viewContext)
        reminder.title = reminderTitle
        myList.addToReminders(reminder)
        try save()
    }
    
    // MARK: - Fetch Reminder Counts
    // Fetches the count of reminders based on specific conditions
    static func getTodayReminderCount() -> Int {
        let calendar = Calendar.current
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        request.predicate = NSPredicate(format: "reminderDate >= %@ AND reminderDate <= %@ AND isCompleted == %d", startOfDay as NSDate, endOfDay! as NSDate, 0)
        
        do {
            let noteData = try CoreDataProvider.shared.viewContext.fetch(request)
            return noteData.count
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // MARK: - Fetch Scheduled Reminder Count
    // Fetches count of scheduled reminders (reminders with a time or date set)
    static func getScheduleReminderCount() -> Int {
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted = %d AND (reminderTime != nil OR reminderDate != nil)", 0)
        
        do {
            let noteData = try CoreDataProvider.shared.viewContext.fetch(request)
            return noteData.count
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // MARK: - Fetch All Reminder Count
    // Fetches count of all uncompleted reminders
    static func getAllReminderCount() -> Int {
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted = %d", 0)
        
        do {
            let noteData = try CoreDataProvider.shared.viewContext.fetch(request)
            return noteData.count
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // MARK: - Fetch Completed Reminder Count
    // Fetches count of all completed reminders
    static func getAllCompletedReminderCount() -> Int {
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted = %d", 1)
        
        do {
            let noteData = try CoreDataProvider.shared.viewContext.fetch(request)
            return noteData.count
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // MARK: - Fetch Today's Reminders
    // Fetches all reminders for today
    static func getTodayList() -> [Reminders] {
        let calendar = Calendar.current
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        request.predicate = NSPredicate(format: "reminderDate >= %@ AND reminderDate <= %@ AND isCompleted == %d", startOfDay as NSDate, endOfDay! as NSDate, 0)
        
        do {
            let noteData = try CoreDataProvider.shared.viewContext.fetch(request)
            return noteData
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
