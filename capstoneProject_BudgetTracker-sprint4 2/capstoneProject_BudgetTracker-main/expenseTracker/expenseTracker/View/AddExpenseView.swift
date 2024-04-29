//
//  AddExpenseView.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/16/24.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var expenseTitle: String = ""
    @State private var expenseDescription: String = ""
    @State private var expenseAmount: CGFloat = 0
    @State private var expenseDate: Date = .init()
    @State private var expenseCategory: Category?
    @Query (animation: .snappy) private var allCategories: [Category]
    var body: some View {
        NavigationStack{
            List{
                Section("Title"){
                    TextField("MacBook Pro 2023", text: $expenseTitle)
                }
                Section("Description"){
                    TextField("Used student discount", text: $expenseDescription)
                }
                Section("Amount"){
                    HStack(spacing: 4){
                        Text("$").fontWeight(.semibold)
                        TextField("Used student discount", value: $expenseAmount, formatter: formatterAmount).keyboardType(.numberPad)
                    }
                }
                Section("Date"){
                    DatePicker("", selection: $expenseDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                if !allCategories.isEmpty{
                    HStack{
                        Text("Cateogry")
                        Spacer()
                        
                        Menu{
                            ForEach(allCategories) { category in
                                Button(category.categoryName) {
                                    self.expenseCategory = category
                                }
                                
                            }
                            Button("None") {
                                expenseCategory = nil
                            }
                        } label: {
                            if let categoryName = expenseCategory?.categoryName {
                                Text(categoryName)
                            }
                            else{
                                Text("None")
                            }
                        }
                        
                    }
                }
                
            }
            .navigationTitle("Add New Expense").font(.title2)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){ dismiss() }
                        .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add", action: addExpenses).disabled(addButtonDisabled)
                }
            }
        }
    }
    
    var addButtonDisabled: Bool{
        return expenseTitle.isEmpty || expenseAmount == .zero
    }
    
    func addExpenses(){
        let expense = Expense(title: expenseTitle, subTitle: expenseDescription, amount: expenseAmount, date: expenseDate, category: expenseCategory)
        context.insert(expense)
        dismiss()
    }
    
    var formatterAmount: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
