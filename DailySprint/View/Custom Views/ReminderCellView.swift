//
//  ReminderCellView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import SwiftUI
import CoreData

struct ReminderCellView: View {
    
    // Enum to define different events triggered by the user in the cell
    enum ReminderCellEvents {
        case select
        case checkedChanged(Reminders)
        case showDetail(Reminders)
    }
    
    // Properties passed to the view
    let reminder: Reminders  // Reminder object that holds data for each reminder
    let isSelected: Bool  // Boolean to indicate if the reminder is selected
    let onSelect: (ReminderCellEvents) -> Void  // Closure to handle events triggered by the cell
    
    let delay = Delay()  // Custom delay handler for toggling completion
    
    @State private var checked: Bool = false  // Local state to manage the checked status of the reminder
    
    // Helper function to format the reminder date
    private func formatDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack {
            // Checkbox icon to toggle completion status
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .opacity(0.4)
                .onTapGesture {
                    checked.toggle()  // Toggle the completion status
                    
                    if checked {
                        // Trigger checkedChanged event with a delay when checked
                        delay.performWork {
                            onSelect(.checkedChanged(reminder))
                        }
                    } else {
                        // Cancel any ongoing delayed action if unchecked
                        delay.cancel()
                    }
                }
                .padding(.trailing, 10)
            
            // Reminder details
            VStack(alignment: .leading) {
                Text(reminder.title ?? "")  // Display the title of the reminder
                
                // Display the notes if present
                if let notes = reminder.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Display the reminder's date and time, if available
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatDate(reminderDate))  // Format and display the date
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted(date: .omitted, time: .shortened))  // Format and display the time
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .foregroundStyle(.gray)
            }
            Spacer()
            
            // Info icon to show the reminder details when tapped
            Image(systemName: "info.circle.fill")
                .opacity(isSelected ? 1.0 : 0.0)
                .onTapGesture {
                    onSelect(.select)  // Trigger the select event when tapped
                }
        }
        .contentShape(Rectangle())  // Make the whole row tappable
        .onTapGesture {
            onSelect(.showDetail(reminder))  // Trigger showDetail event when tapped
        }
    }
}

#Preview {
    ReminderCellView(reminder: PreviewData.reminder, isSelected: true) { _ in }
}
