//
//  Category.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI
import SwiftData

@Model
class Category{
    var categoryName: String
    @Relationship(deleteRule: .cascade, inverse: \Expense.cateogry)
    var expenses: [Expense]?
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
    
    
}
