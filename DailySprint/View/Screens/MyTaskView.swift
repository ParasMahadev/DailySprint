//
//  MyTaskView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import SwiftUI
import CoreData

struct MyTaskView: View {
    
    // MARK: - Variables
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyTaskList>       // Fetching task list from Core Data
    @Environment(\.managedObjectContext) private var context    // Access to Core Data context
    @EnvironmentObject private var viewModel: MyTaskViewModel   // EnvironmentObject to manage view model state
    
    @Environment(\.colorScheme) private var colorScheme         // To detect current color scheme (light/dark)
    @State private var isPresented: Bool = false                // State for presenting the task creation sheet
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                // Main List view with sections for different task categories
                List {
                    // Stats for different task categories (Today, Scheduled, All, Completed)
                    VStack(spacing: 10) {
                        HStack {
                            ReminderStatsView(icon: "calendar", title: "Today", count: viewModel.todayCount, color: .red)
                                .onTapGesture { navigateTo(.today) }
                            ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: viewModel.scheduledCount, color: .green)
                                .onTapGesture { navigateTo(.scheduled) }
                        }
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            ReminderStatsView(icon: "tray.circle.fill", title: "All", count: viewModel.allCount, color: .blue)
                                .onTapGesture { navigateTo(.all) }
                            ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: viewModel.completedCount, color: .red)
                                .onTapGesture { navigateTo(.completed) }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowSeparator(.hidden)  // Hide separators between sections
                    .padding(.horizontal, 20)
                    
                    // Display task list fetched from Core Data
                    ForEach(myListResults) { myList in
                        NavigationLink(value: myList) {
                            MyTaskCellView(myTask: myList)  // Task cell view
                                .font(.title3)
                                .contentShape(Rectangle())  // Make the whole cell tappable
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteTask(at: offsets, tasks: myListResults)  // Delete task when swiped
                    }
                }
                .listStyle(.plain)  // Basic list style
                .searchable(text: $viewModel.search)  // Searchable list
                .onChange(of: viewModel.search, { oldValue, newValue in
                    viewModel.handleSearch(newValue)  // Handle search text change
                })
                .overlay(alignment: .center) {
                    // Display search overlay when searching
                    if !viewModel.search.isEmpty {
                        SearchOverlayView(filteredReminders: viewModel.filteredReminders, viewModel: viewModel)
                    }
                }
                .sheet(isPresented: $isPresented) {
                    // Sheet to add a new task
                    NavigationView {
                        AddNewTaskView { name, color in
                            do {
                                try DatabseServices.saveMyList(name, color)  // Save new task
                            } catch {
                                print(error.localizedDescription)  // Handle errors
                            }
                        }
                    }
                }
                
                // Button to present the sheet for adding a new task
                Button(action: {
                    isPresented = true  // Show sheet when button is pressed
                }) {
                    Image(systemName: "plus.circle.fill")  // Plus icon
                        .foregroundStyle(Color(colorScheme == .dark ? .white : .black))  // Change icon color based on theme
                        .font(.system(size: 50))  // Icon size
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(viewModel.searching ? 0.0 : 1.0)  // Hide button when searching
                }
                .padding()
            }
            .navigationTitle("My Tasks")  // Navigation bar title
            .navigationDestination(for: MyTaskList.self) { myTaskList in
               // Navigation destination for task list detail view
               ReminderListView(myList: myTaskList, isOnlyView: false)
            }
            .navigationDestination(isPresented: $viewModel.isNavigateDetailView) {
                // Navigation to stats detail view
                if let statsType = viewModel.reminderStatsType {
                    let reminders = viewModel.fetchReminders(for: statsType)
                    SelectedListView(reminders: reminders, navTitle: statsType.title, viewModel: viewModel, statsType: statsType)
                } else {
                    Text("No reminders available")
                }
            }
        }
        .onAppear {
            viewModel.fetchTaskCounts()  // Fetch task counts when the view appears
        }
    }

    // Navigate to a specific stats view (Today, Scheduled, etc.)
    private func navigateTo(_ type: ReminderStatsType) {
        viewModel.reminderStatsType = type
        viewModel.isNavigateDetailView = true
    }
}
