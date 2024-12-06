//
//  ReminderEditConfig.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation

// MARK: - Structure for Editing Reminder Configuration
struct ReminderEditConfig {
    var title: String = ""               // Title of the reminder
    var notes: String?                   // Optional notes for the reminder
    var isCompleted: Bool = false        // Flag indicating whether the reminder is completed
    var hasDate: Bool = false            // Flag indicating if the reminder has a date
    var hasTime: Bool = false            // Flag indicating if the reminder has a time
    var reminderDate: Date = Date()      // The date of the reminder
    var reminderTime: Date = Date()      // The time of the reminder
    
    // Default initializer with default values
    init() { }
    
    // Custom initializer that configures the edit configuration based on an existing Reminders object
    init(reminder: Reminders) {
        title = reminder.title ?? ""                    // If title is nil, use an empty string
        notes = reminder.notes                          // Set the notes
        isCompleted = reminder.isCompleted              // Set completion status
        reminderDate = reminder.reminderDate ?? Date()  // Set the reminder date, or use current date if nil
        reminderTime = reminder.reminderTime ?? Date()  // Set the reminder time, or use current time if nil
        hasDate = reminder.reminderDate != nil          // Check if reminder has a date
        hasTime = reminder.reminderTime != nil          // Check if reminder has a time
    }
}
