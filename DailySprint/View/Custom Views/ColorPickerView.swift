//
//  ColorPickerView1.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/3/24.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var selectedColor: Color  // Binding to pass selected color back to the parent view
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]  // List of colors for the picker

    var body: some View {
        HStack {
            // Iterates over the list of colors and creates a circle for each color
            ForEach(colors, id: \.self) { color in
                ZStack {
                    // Circle filled with the color
                    Circle().fill()
                        .foregroundColor(color)
                        .padding(2)
                    
                    // Circle border to indicate the selected color
                    Circle()
                        .strokeBorder(selectedColor == color ? .gray : .clear, lineWidth: 4)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))  // Highlight selected color
                }
                .onTapGesture {
                    selectedColor = color  // Update the selected color when tapped
                }
            }
        }
        .padding()  // Padding around the entire HStack
        .frame(maxWidth: .infinity, maxHeight: 100)  // Ensures it takes up full width but with a fixed height
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))  // Rounded corners for a smooth look
        
        // Description text below the color picker
        Text("Colors represent priority: Red (High), Green (Medium), Blue (Low), and others to help organize your tasks effectively")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(5)
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.yellow))  // Preview with yellow as the selected color
}
