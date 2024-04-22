//
//  expenseTrackerApp.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI

@main
struct expenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Expense.self, Category.self])
    }
}
