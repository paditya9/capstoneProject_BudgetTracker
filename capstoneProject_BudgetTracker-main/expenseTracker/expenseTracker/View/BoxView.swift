//
//  BoxView.swift
//  expenseTracker
//
//  Created by Adityaraj - CodePath on 4/16/24.
//

import SwiftUI

struct BoxView: View {
    @Bindable var expense: Expense
    var displayTag: Bool = true
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(expense.title)
                Text(expense.subTitle).font(.caption2).foregroundStyle(.gray)
                
                if let categoryName = expense.cateogry?.categoryName, displayTag{
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.green.gradient, in: .capsule)
                }
            }
            .lineLimit(2)
            Spacer(minLength: 6)
            Text(expense.currencyString).font(.title3.bold())
        }
    }
}
