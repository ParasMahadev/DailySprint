//
//  AddNewTaskView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//

import SwiftUI

// A view to add a new task, including task name and color selection
struct AddNewTaskView: View {
    
    // MARK: - Variables
    @Environment(\.dismiss) private var dismiss  // To dismiss the view
    @StateObject private var viewModel = TaskViewModel()  // ViewModel to manage task data
    var onSave: (String, UIColor) -> Void  // Callback to handle saving the task
    
    // MARK: - Main View
    var body: some View {
        VStack {
            // Task name input section with color icon
            VStack {
                Image(systemName: "line.3.horizontal.circle.fill")
                    .foregroundColor(viewModel.selectedColor)  // Display selected color on icon
                    .font(.system(size: 100))  // Icon size
                
                TextField("Task Name", text: $viewModel.name)
                    .multilineTextAlignment(.center)  // Center text alignment
                    .textFieldStyle(.roundedBorder)  // Rounded border style
            }
            .padding()  // Padding around input section
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))  // Rounded corner
            
            // Color picker to select task color
            ColorPickerView(selectedColor: $viewModel.selectedColor)
            Spacer()  // Space to push content upwards
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Full-screen view
        .toolbar {
            // Toolbar with "New Task" title and action buttons
            ToolbarItem(placement: .principal) {
                Text("New Task")
                    .font(.headline)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()  // Close the view
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.saveTask()  // Save task
                    dismiss()  // Close the view
                }
                .disabled(!viewModel.isFormValid)  // Disable if form is invalid
            }
        }
        // On view appear, set the onSave callback for task saving
        .onAppear {
            viewModel.onSave = onSave
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        AddNewTaskView(onSave: {(_, _) in })
    }
}
