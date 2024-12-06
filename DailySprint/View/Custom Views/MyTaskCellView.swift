//
//  MyTaskCellView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import SwiftUI

struct MyTaskCellView: View {
    
    let myTask: MyTaskList  // Task data passed from parent view
    
    @Environment(\.colorScheme) var colorScheme  // Accesses the system's current color scheme (dark/light mode)

    var body: some View {
        VStack {
            HStack {
                // Icon representing the task, colored based on the task's color
                Image(systemName: "line.3.horizontal.circle.fill")
                    .foregroundColor(Color(myTask.color))  // Uses the color associated with the task
                
                // Task name displayed next to the icon
                Text(myTask.name)
                    .frame(maxWidth: .infinity, alignment: .leading)          // Ensures text aligns to the left and occupies available space
                    .foregroundColor(colorScheme == .dark ? .white : .black)  // Adjusts text color based on dark/light mode
                
                Spacer()
            }
            .frame(height: 30)      // Fixed height for the task cell
            .padding(.horizontal)   // Horizontal padding around the content
        }
    }
}

#Preview {
    MyTaskCellView(myTask: PreviewData.myTask)  // Previewing the view with a sample task
}
