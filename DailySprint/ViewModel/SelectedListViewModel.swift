//
//  SelectedListViewModel.swift
//  DailySprint
//
//  Created by Paras Navadiya on 06/12/24.
//

import SwiftUI
import Combine

class SelectedListViewModel: ObservableObject {
    
    // Published variables to update the view
    @Published var reminders: [Reminders]
    @Published var selectedReminder: Reminders?
    @Published var showReminderDetail: Bool = false
    @Published var navTitle: String
    private var viewModel: MyTaskViewModel
    private var statsType: ReminderStatsType
    
    init(reminders: [Reminders], navTitle: String, viewModel: MyTaskViewModel, statsType: ReminderStatsType) {
        self.reminders = reminders
        self.navTitle = navTitle
        self.viewModel = viewModel
        self.statsType = statsType
    }
    
    // MARK: - Reminder Selection
    func isReminderSelected(_ reminder: Reminders) -> Bool {
        return selectedReminder?.objectID == reminder.objectID
    }
    
    // MARK: - Reminder Checked Changed
    func reminderCheckedChanged(reminder: Reminders) {
        guard navTitle != ReminderStatsType.completed.title else { return }
        
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = !reminder.isCompleted
        do {
            try DatabseServices.updateReminder(reminder: reminder, editConfig: editConfig)
            viewModel.fetchTaskCounts()
            // Update the reminders list after checking a reminder
            self.fetchReminders()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Delete Reminder
    func deleteReminder(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try DatabseServices.deleteReminder(reminder: reminder)
                viewModel.fetchTaskCounts()
                // Update the reminders list after deletion
                self.fetchReminders()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Show Reminder Detail
    func showReminderDetailView(for reminder: Reminders) {
        selectedReminder = reminder
        showReminderDetail = true
    }
    
    // MARK: - Fetch Reminders
    func fetchReminders() {
        // Fetch the updated reminders based on the current statsType
        reminders = viewModel.fetchReminders(for: statsType)
    }
}

