//
//  GroupingExpense.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/16/24.
//

import SwiftUI

struct GroupingExpense: Identifiable {
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
    
    var groupTitle: String{
        let calender = Calendar.current
        if calender.isDateInToday(date){return "Today"}
        else if calender.isDateInYesterday(date){return "Yesterday"}
        else{return date.formatted(date: .abbreviated, time: .omitted)}
    }
}
