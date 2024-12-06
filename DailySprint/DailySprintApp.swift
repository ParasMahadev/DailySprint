//
//  DailySprintApp.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//

import SwiftUI

@main
struct DailySprintApp: App {
    
    let persistentContainer = CoreDataProvider.shared.persistentContainer
    @State var isActive: Bool = false
    
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissed granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                if self.isActive {
                    MyTaskView()
                        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
                        .environmentObject(MyTaskViewModel(context: persistentContainer.viewContext))
                } else {
                    Image("splashScreen")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            
            
            
            
        }
    }
}



