//
//  MyTaskViewModel.swift
//  DailySprint
//
//  Created by Paras Navadiya on 06/12/24.
//

import SwiftUI
import CoreData

class MyTaskViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var todayCount: Int = 0
    @Published var allCount: Int = 0
    @Published var scheduledCount: Int = 0
    @Published var completedCount: Int = 0
    
    @Published var reminderStatsType: ReminderStatsType?
    @Published var isNavigateDetailView: Bool = false
    @Published var filteredReminders: [Reminders] = []  // Stores filtered reminders based on search query
    @Published var search: String = ""  // Search text
    @Published var searching: Bool = false  // Indicates if a search is active

    private let context: NSManagedObjectContext  // CoreData context

    // MARK: - Init Method
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTaskCounts()  // Fetch the task counts on initialization
    }
    
    // MARK: - Task Counting
    // Fetches task counts for different categories
    func fetchTaskCounts() {
        todayCount = DatabseServices.getTodayReminderCount()
        allCount = DatabseServices.getAllReminderCount()
        scheduledCount = DatabseServices.getScheduleReminderCount()
        completedCount = DatabseServices.getAllCompletedReminderCount()
    }
    
    // MARK: - Search Functionality
    // Handles the search logic, updating filtered reminders
    func handleSearch(_ searchTerm: String) {
        searching = !searchTerm.isEmpty
        if searching {
            let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ AND isCompleted = %d", searchTerm, 0)  // Filters active (incomplete) reminders by title
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Reminders.title, ascending: true)]
            
            do {
                filteredReminders = try context.fetch(request)  // Fetch filtered reminders
            } catch {
                print("Failed to fetch reminders: \(error.localizedDescription)")
                filteredReminders = []
            }
        } else {
            filteredReminders = []  // Reset filtered reminders if no search term
        }
    }
    
    // MARK: - Fetch Reminders Based on Stats Type
    // Fetches reminders based on the selected reminder stats type (e.g., today, scheduled, completed)
    func fetchReminders(for statsType: ReminderStatsType) -> [Reminders] {
        let request: NSFetchRequest<Reminders> = Reminders.fetchRequest()
        
        switch statsType {
        case .today:
            // Fetch reminders for today based on reminderDate
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
            request.predicate = NSPredicate(format: "reminderDate >= %@ AND reminderDate <= %@ AND isCompleted == %d", startOfDay as NSDate, endOfDay! as NSDate, 0)
        case .scheduled:
            request.predicate = NSPredicate(format: "isCompleted = %d AND (reminderTime != nil OR reminderDate != nil)", 0)
        case .all:
            request.predicate = NSPredicate(format: "isCompleted == %d", 0)  // Fetch all active reminders
        case .completed:
            request.predicate = NSPredicate(format: "isCompleted == %d", 1)  // Fetch completed reminders
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Reminders.title, ascending: true)]
        
        do {
            return try context.fetch(request)  // Fetch reminders based on the stats type
        } catch {
            print("Failed to fetch reminders: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Delete Tasks
    // Deletes tasks from the `MyTaskList` at the given index offsets
    func deleteTask(at offsets: IndexSet, tasks: FetchedResults<MyTaskList>) {
        for index in offsets {
            let taskToDelete = tasks[index]
            context.delete(taskToDelete)
        }
        saveContext()  // Save changes after deletion
    }
    
    // MARK: - Delete Reminders
    // Deletes reminders from filtered reminders at the given index offsets
    func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            let reminderToDelete = filteredReminders[index]
            context.delete(reminderToDelete)
        }
        saveContext()  // Save changes after deletion
    }
    
    // MARK: - Save Context
    // Saves changes to the context (CoreData)
    private func saveContext() {
        do {
            try context.save()  // Save the context after modifying it (e.g., after deleting or adding reminders)
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

