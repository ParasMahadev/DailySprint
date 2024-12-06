//
//  SearchOverlayView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 06/12/24.
//

import SwiftUI

// MARK: - SearchOverlayView
// This view displays a list of filtered reminders and allows users to interact with them
struct SearchOverlayView: View {
    
    // MARK: - Variables
    // A list of filtered reminders to be displayed in the list
    let filteredReminders: [Reminders]
    
    // A state variable to keep track of the selected reminder
    @State private var selectedReminder: Reminders?

    // A state variable to control the display of the reminder detail sheet
    @State private var showReminderDetail: Bool = false
    
    // The view model that handles data fetching and task count updates
    @StateObject var viewModel: MyTaskViewModel = MyTaskViewModel(context: DatabseServices.viewContext)
    
    // MARK: - Body
    var body: some View {
        
        // List view to display filtered reminders
        List(filteredReminders, id: \.objectID) { reminder in
            // Custom cell view for each reminder
            ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                // Handle the events triggered by interaction with the reminder cell
                switch event {
                    // Show the reminder details when tapped
                    case .showDetail(let reminder):
                        selectedReminder = reminder
                    // Toggle completion status when checked or unchecked
                    case .checkedChanged(let reminder):
                        reminderCheckedChanged(reminder: reminder)
                    // Set the flag to show the reminder detail sheet
                    case .select:
                        showReminderDetail = true
                }
            }
        }
        // Show the reminder detail view in a sheet when a reminder is selected
        .sheet(isPresented: $showReminderDetail, content: {
            ReminderDetailView(reminder: Binding($selectedReminder)!) // Pass the selected reminder as a binding
        })
    }
    
    // MARK: - Functions
    
    // Function to check if a reminder is selected
    // It compares the reminder's objectID with the selected reminder's objectID
    private func isReminderSelected(_ reminder: Reminders) -> Bool {
        selectedReminder?.objectID == reminder.objectID
    }
    
    // Function to handle toggling the completion status of a reminder
    private func reminderCheckedChanged(reminder: Reminders) {
        // Create a configuration to update the reminder
        var editConfig = ReminderEditConfig(reminder: reminder)
        // Toggle the completion status
        editConfig.isCompleted = !reminder.isCompleted
        do {
            // Attempt to update the reminder in the database
            try DatabseServices.updateReminder(reminder: reminder, editConfig: editConfig)
            // Fetch updated task counts after the reminder's status is changed
            viewModel.fetchTaskCounts()
        } catch {
            // Handle any errors that occur during the update
            print("Failed to update reminder: \(error.localizedDescription)")
        }
    }
}

