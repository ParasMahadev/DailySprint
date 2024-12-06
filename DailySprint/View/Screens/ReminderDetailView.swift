//
//  ReminderDetailView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//


import SwiftUI

struct ReminderDetailView: View {
    
    @Environment(\.dismiss) private var dismiss  // To dismiss the view
    
    @Binding var reminder: Reminders  // Bound reminder object to update
    @State var editConfig: ReminderEditConfig = ReminderEditConfig()  // State for editing configuration
    @EnvironmentObject var viewModel: MyTaskViewModel  // EnvironmentObject for managing task-related state
    
    // Computed property to check if the form is valid (i.e., title is not empty)
    private var isFormValid: Bool {
        !editConfig.title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Section for title and notes input
                    Section {
                        TextField("Title", text: $editConfig.title)  // Binding title to editConfig
                        TextField("Notes", text: $editConfig.notes ?? "")  // Binding notes to editConfig
                    }
                    
                    // Section for date and time toggles and pickers
                    Section {
                        Toggle(isOn: $editConfig.hasDate) {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                        }
                        
                        if editConfig.hasDate {
                            DatePicker("Select Date", selection: $editConfig.reminderDate, displayedComponents: .date)
                        }
                        
                        Toggle(isOn: $editConfig.hasTime) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                        
                        if editConfig.hasTime {
                            DatePicker("Select Time", selection: $editConfig.reminderTime, displayedComponents: .hourAndMinute)
                        }
                    }
                    
                    // Section for selecting the list the reminder belongs to
                    Section {
                        NavigationLink {
                            SelectListView(selectedList: $reminder.list)  // Navigation to select a list
                        } label: {
                            HStack {
                                Text("List")
                                Spacer()
                                Text(reminder.list!.name)  // Display the current list name
                            }
                        }
                    }
                    
                }
                .listStyle(.insetGrouped)  // Inset grouped style for the list
                
            }
            // On view appear, initialize the editConfig from the reminder
            .onAppear {
                editConfig = ReminderEditConfig(reminder: reminder)
            }
            .toolbar {
                // Toolbar with "Details" title and action buttons
                ToolbarItem(placement: .principal) {
                    Text("Details")
                }
                
                // Done button to save changes if the form is valid
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if isFormValid {
                            // Update the reminder using the editConfig
                            do {
                                try DatabseServices.updateReminder(reminder: reminder, editConfig: editConfig)
                                viewModel.fetchTaskCounts()  // Refresh task counts
                                dismiss()  // Dismiss the view
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .disabled(!isFormValid)  // Disable button if form is invalid
                }
                
                // Cancel button to dismiss without saving changes
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()  // Dismiss the view
                    }
                }
            }
            
        }
    }
}
