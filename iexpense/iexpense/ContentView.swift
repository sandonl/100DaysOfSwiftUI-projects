//
//  ContentView.swift
//  iexpense
//
//  Created by Sandon Lai on 13/3/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
    
    
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // Loads the UserDefaults else will return an empty items array
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                            Spacer()
                            Text("$\(item.amount)")
                                .colourAmount(item.amount)
                        }
                    }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: Button(action: {
                self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                })
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

struct ColourAmount: ViewModifier {
    
    var amount: Int
    
    func body(content: Content) -> some View {
        var foregroundColor = Color.black
        
        if amount <= 10 {
            foregroundColor = Color.green
        } else if amount > 10 && amount <= 100 {
            foregroundColor = Color.blue
        } else if amount > 100 {
            foregroundColor = Color.red
        }
        
        return content
            .foregroundColor(foregroundColor)
    }
}

extension View {
    func colourAmount(_ amount: Int) -> some View {
        self.modifier(ColourAmount(amount: amount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
