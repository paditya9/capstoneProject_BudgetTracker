//
//  ContentView.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: String = "Expenses"
    var body: some View {
        TabView(selection: $currentScreen ){
            ExpenseView(currentScreen: $currentScreen)
                .tag("Expenses")
                .tabItem { Image(systemName: "creditcard.fill")
                Text("Expenses")}
            
            CategoryView()
                .tag("Categories")
                .tabItem { Image(systemName: "list.clipboard.fill")
                    Text("Categories")}
        }
    }
}

#Preview {
    ContentView()
}
