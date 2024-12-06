//
//  CustomOperators.swift
//  DailySprint
//
//  Created by Paras Navadiya on 12/4/24.
//

import Foundation
import SwiftUI 

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
