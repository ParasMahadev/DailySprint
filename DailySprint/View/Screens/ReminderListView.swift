//
//  ReminderListView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import SwiftUI
import CoreData

struct ReminderListView: View {
    
    //MARK: - Variables
    let myList: MyTaskList                                   // Task list to show reminders for
    @State private var openAddReminder: Bool = false         // Flag to open reminder addition alert
    @State private var title: String = ""                    // Title of the new reminder
    @State private var selectedReminder: Reminders?          // Currently selected reminder
    @State private var showReminderDetail: Bool = false      // Flag to show reminder details
    @State var delayCall: DispatchWorkItem?                  // Delay helper for debounce-like behavior
    @FetchRequest var reminders: FetchedResults<Reminders>   // Fetched reminders for the task list
    var isOnlyView: Bool?                                    // Flag to indicate if it's a view-only screen
    @EnvironmentObject var viewModel: MyTaskViewModel        // ViewModel to manage task counts and state
    @Environment(\.colorScheme) var colorScheme              // Current color scheme (light/dark)

    private var isFormValid: Bool {
        !title.isEmpty  // Check if the title is valid (non-empty)
    }
    
    
    //MARK: - Init Method
    init(myList: MyTaskList, isOnlyView: Bool? = false) {
        self.myList = myList
        self.isOnlyView = isOnlyView
        _reminders = FetchRequest(fetchRequest: myList.remindersByMyListRequest)  // Fetch reminders for the task list
    }
    
    //MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(self.colorScheme == .dark ? .black : .systemGray6)  // Background color based on scheme
                .ignoresSafeArea(.all)

            VStack {
                List {
                    // Display reminders in a list, each with actions
                    ForEach(reminders) { reminder in
                        ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                            switch event {
                            case .showDetail(let reminder):
                                selectedReminder = reminder  // Show details for selected reminder
                            case .checkedChanged(let reminder):
                                reminderCheckedChanged(reminder: reminder)  // Handle completion state change
                            case .select:
                                showReminderDetail = true  // Show reminder detail view
                            }
                        }
                    }
                    .onDelete(perform: deleteReminder)  // Handle reminder deletion
                }
                .scrollContentBackground(.hidden)

                Spacer()
            }
            .sheet(isPresented: $showReminderDetail, content: {
                ReminderDetailView(reminder: Binding($selectedReminder)!)  // Show reminder details in sheet
            })

            .toolbar(content: {
                // Toolbar item with "Done" button to close detail view
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedReminder = nil  // Clear selected reminder
                    }.opacity(selectedReminder != nil ? 1.0 : 0.0)  // Only show if reminder is selected
                }
            })
            .alert("New Reminder", isPresented: $openAddReminder, actions: {
                TextField("", text: $title)  // Input for new reminder title
                Button("Cancel", role: .cancel) {
                    title = ""  // Reset title on cancel
                }
                Button("Done") {
                    if isFormValid {
                        // Save new reminder if title is valid
                        do {
                            try DatabseServices.saveReminderToMyList(myList: myList, reminderTitle: title)
                            title = ""  // Reset title after saving
                            viewModel.fetchTaskCounts()  // Refresh task counts
                        } catch {
                            print(error.localizedDescription)  // Handle error
                        }
                    }
                }
            })
            .navigationTitle(myList.name)  // Set navigation title to the task list name
            .navigationBarTitleDisplayMode(.large)  // Display large title
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Add reminder button, visible only if it's not a view-only screen
            if !(isOnlyView ?? false) {
                Button {
                    openAddReminder = true  // Show new reminder alert
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Color(self.colorScheme == .dark ? .white : .black))  // Icon color based on scheme
                        .font(.system(size: 50))  // Large icon size
                        .padding(.trailing)
                }
            }
        }
    }
    
    //MARK: - Functions
    private func delayCall(delay: Double, completion: @escaping () -> ()) {
        // Helper to delay execution of a task
        delayCall?.cancel()
        delayCall = DispatchWorkItem {
            completion()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: delayCall!)  // Delay completion call
    }
    
    private func reminderCheckedChanged(reminder: Reminders) {
        // Handle the completion state change of a reminder
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = !reminder.isCompleted  // Toggle completion status
        do {
            try DatabseServices.updateReminder(reminder: reminder, editConfig: editConfig)  // Save the update
            viewModel.fetchTaskCounts()  // Refresh task counts
        } catch {}
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        // Handle deletion of selected reminders
        indexSet.forEach { index in
            let reminder = reminders[index]
            do {
                try DatabseServices.deleteReminder(reminder: reminder)  // Delete reminder from database
                viewModel.fetchTaskCounts()  // Refresh task counts
            } catch {
                print(error)  
            }
        }
    }
    
    private func isReminderSelected(_ reminder: Reminders) -> Bool {
        // Check if a reminder is selected for detail view
        selectedReminder?.objectID == reminder.objectID
    }
}

