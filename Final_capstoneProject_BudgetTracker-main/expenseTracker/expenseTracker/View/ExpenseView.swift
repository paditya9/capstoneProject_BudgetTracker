//
//  ExpenseView.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    @Binding var currentScreen: String
    @Query(sort: [SortDescriptor(\Expense.date, order: .reverse)], animation: .smooth)
    private var allExpenses: [Expense]
    @Environment(\.modelContext) private var context
    @State private var groupingExpenses: [GroupingExpense] = []
    @State private var orginalGroupingExpenses: [GroupingExpense] = []
    @State private var addExpense: Bool = false
    @State private var searchBar: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($groupingExpenses){ $group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            // Box view
                            BoxView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                    Button{
                                        context.delete(expense)
                                        withAnimation{
                                            group.expenses.removeAll(where: { $0.id == expense.id})
                                            if group.expenses.isEmpty{
                                                groupingExpenses.removeAll(where: { $0.id == group.id})
                                            }
                                        }
                                    }
                                label: {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(.red)
                                    
                                }
                        }
                    }
                }
            }
            .navigationTitle("Expense Dashboard")
            .searchable(text: $searchBar, placement: .navigationBarDrawer, prompt: Text("Search Bar"))
            .overlay{ if allExpenses.isEmpty || groupingExpenses.isEmpty{
                ContentUnavailableView("No Expense Recorded", systemImage: "tray")
            }}
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addExpense.toggle()
                    }
                label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                }
            }
        }
        .onChange(of: searchBar, initial: false){ oldValue, newValue in
            if !newValue.isEmpty{
                makeFilterExpense(newValue)
            }
            else{
                groupingExpenses = orginalGroupingExpenses
            }
        }
        .onChange(of: allExpenses, initial: true){ oldValue, newValue in
            if newValue.count > oldValue.count || groupingExpenses.isEmpty || currentScreen == "Categories"{
                makeGroupExpense(newValue)
            }
        }
        .sheet(isPresented: $addExpense){
            AddExpenseView()
                .interactiveDismissDisabled()
        }
    }
    
    func makeFilterExpense(_ text: String){
        Task.detached(priority:.high){
            let query = text.lowercased()
            let filterExpenses = orginalGroupingExpenses.compactMap { group -> GroupingExpense? in
                let expenses = group.expenses.filter({ $0.title.lowercased().contains(query)})
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run{
                groupingExpenses = filterExpenses
            }
        }
    }
    
    func makeGroupExpense(_ expenses: [Expense]){
        Task.detached(priority: .high){
            let group = Dictionary(grouping: expenses) { expenses in
                let dataComp = Calendar.current.dateComponents([.day, .month, .year], from: expenses.date)
                
                return dataComp
                
            }
            let sortDict = group.sorted{
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            await MainActor.run{
                groupingExpenses = sortDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                    
                })
                orginalGroupingExpenses = groupingExpenses
                
            }
        }
    }
}


#Preview {
    ContentView()
}
