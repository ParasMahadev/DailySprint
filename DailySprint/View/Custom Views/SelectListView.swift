//
//  SelectListView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//


import SwiftUI

// MARK: - SelectListView
// View for selecting a task list from Core Data
struct SelectListView: View {
    
    // Fetch all MyTaskList objects from Core Data
    @FetchRequest(sortDescriptors: [])
    private var myListsFetchResults: FetchedResults<MyTaskList>
    
    // Binding to the selected list
    @Binding var selectedList: MyTaskList?
    
    // MARK: - Body
    var body: some View {
        List(myListsFetchResults) { myList in
            HStack {
                // Display task cell
                MyTaskCellView(myTask: myList)
                    .font(.title3)
                    .onTapGesture {
                        // Set the selected list
                        self.selectedList = myList
                    }
                Spacer()
                
                // Show checkmark if selected
                if selectedList == myList {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle()) // Makes cell tappable
        }
        .toolbar {
            // Toolbar with the title
            ToolbarItem(placement: .principal) {
                Text("List")
                    .font(.headline)
            }
        }
    }
}

// MARK: - Preview
#Preview {
        NavigationView {
            SelectListView(selectedList: .constant(PreviewData.myTask))
                .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
}
