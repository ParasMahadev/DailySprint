//
//  TaskViewModel.swift
//  DailySprint
//
//  Created by Paras Navadiya on 06/12/24.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedColor: Color = .yellow
    
    // A computed property to validate the form
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    // Callback for saving the task
    var onSave: ((String, UIColor) -> Void)?
    
    func saveTask() {
        guard isFormValid else { return }
        onSave?(name, UIColor(selectedColor))
    }
}
