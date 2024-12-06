//
//  ReminderStatsView.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import SwiftUI

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .scheduled:
            return "Scheduled"
        case .all:
            return "All"
        case .completed:
            return "Completed"
        }
    }
}

struct ReminderStatsView: View {
    
    let icon: String
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(color)
                    Text(title)
                }
                Spacer()
                
                Text("\(count)")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
    }
}
