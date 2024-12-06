//
//  SelectedListView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 06/12/24.
//

import SwiftUI

struct SelectedListView: View {
    
    // MARK: - Variables
    @StateObject private var viewModel: SelectedListViewModel  // ViewModel to manage the state of the list and its reminders
    
    // MARK: - Init Method
    init(reminders: [Reminders], navTitle: String, viewModel: MyTaskViewModel, statsType: ReminderStatsType) {
        _viewModel = StateObject(wrappedValue: SelectedListViewModel(reminders: reminders, navTitle: navTitle, viewModel: viewModel, statsType: statsType))  // Initialize ViewModel with provided data
    }
    
    // MARK: - Body
    var body: some View {
        List {
            // Display each reminder in the list with event handling
            ForEach(viewModel.reminders) { reminder in
                ReminderCellView(reminder: reminder, isSelected: viewModel.isReminderSelected(reminder)) { event in
                    switch event {
                        case .showDetail(let reminder):
                            viewModel.showReminderDetailView(for: reminder)  // Show detail for the selected reminder
                        case .checkedChanged(let reminder):
                            viewModel.reminderCheckedChanged(reminder: reminder)  // Handle completion state toggle for reminder
                        case .select:
                            viewModel.showReminderDetail = true  // Show reminder detail when selected
                    }
                }
            }
            .onDelete(perform: viewModel.deleteReminder)  // Delete reminder from list
        }
        .sheet(isPresented: $viewModel.showReminderDetail, content: {
            // Display reminder detail view in a sheet
            ReminderDetailView(reminder: Binding($viewModel.selectedReminder)!)
        })
        .navigationTitle(viewModel.navTitle)  // Set navigation title dynamically based on the ViewModel
    }
}


