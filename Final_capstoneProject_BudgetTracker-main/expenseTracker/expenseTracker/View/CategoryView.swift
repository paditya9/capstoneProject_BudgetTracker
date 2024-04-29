//
//  CategoryView.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI
import SwiftData
struct CategoryView: View {
    @Query(animation: .snappy) private var allCategory: [Category]
    @Environment(\.modelContext) private var context
    @State private var categoryName: String = ""
    @State private var addCategory: Bool = false
    @State private var delete: Bool = false
    @State private var reqCatrgory: Category?
    var body: some View {
        NavigationStack{
            List{
                ForEach(allCategory.sorted( by: {
                    ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })) { category in
                    DisclosureGroup {
                        if let expenses = category.expenses, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                BoxView(expense: expense, displayTag: false)
                            }
                        } else{
                            ContentUnavailableView {
                                Label("No Categories Recorded", systemImage: "tray")
                            }
                        }
                    }
                label: {
                    Text(category.categoryName)
                    }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button{
                        delete.toggle()
                        reqCatrgory = category
                    } label: {
                            Image(systemName: "trash.fill")
                        }
                    .tint(.red)
                    }
                }
            }
            .navigationTitle("Categories")
            .overlay {
                if allCategory.isEmpty{
                    ContentUnavailableView {
                        Label("No Categories Recorded", systemImage: "tray")
                    }
                }
            }
            
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addCategory.toggle()
                    }
                label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $addCategory){
                categoryName = ""
            } content: {
                NavigationStack{
                    List{
                        Section("Title") {
                            TextField("Miscellaneous", text: $categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add"){
                                let category = Category(categoryName: categoryName)
                                context.insert(category)
                                
                                categoryName = ""
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                        
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }
        }
        .alert("If you delete the category, all expenses under the same will be erased", isPresented: $delete){
            Button(role: .destructive) {
                if let reqCatrgory {
                    context.delete(reqCatrgory)
                    self.reqCatrgory = nil
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                reqCatrgory = nil
            } label: {
                Text("Cancel")
            }
        }
    }
}

#Preview {
    CategoryView()
}
