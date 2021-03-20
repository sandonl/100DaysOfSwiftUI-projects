//
//  AddView.swift
//  iexpense
//
//  Created by Sandon Lai on 20/3/21.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = "Personal"
    @ObservedObject var expenses: Expenses
    @State private var incorrectAlert = false
    
    @State private var amount = ""
    @State private var messageAlert = ""
    @State private var dismissMessage = "Got it!"
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types , id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                    if let actualAmount = Int(self.amount) {
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                            self.expenses.items.append(item)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    else {
                        self.messageAlert = "\(self.amount) is not a valid amount"
                        incorrectAlert = true
                    }
            })
            .alert(isPresented: $incorrectAlert) {
                Alert(title: Text("Incorrect Amount"), message: Text(messageAlert), dismissButton: .default(Text(dismissMessage)))
            }
        }
    }
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
