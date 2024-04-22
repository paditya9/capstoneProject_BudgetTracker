//
//  Expense.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/13/24.
//

import SwiftUI

import SwiftData

@Model
class Expense{
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    var cateogry: Category?
    
    init(title:String, subTitle:String, amount:Double, date: Date, category: Category?){
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.cateogry = category
    }
    
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(for: amount) ?? ""
    }
    
}
