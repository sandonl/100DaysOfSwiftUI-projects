//
//  ContentView.swift
//  rest-up
//
//  Created by Sandon Lai on 28/2/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack (spacing: 40){
                // Date Picker and time
                Text("When do you want to wake up?")
                    .font(.headline)

                DatePicker("Please enter a time",
                           selection: $wakeUp,
                           displayedComponents:
                            .hourAndMinute)
                    .labelsHidden()
            
                
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                // Coffee Intake
                Group {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 Cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }

            }
            .navigationBarTitle("Rest Up")
            .navigationBarItems(trailing:
                                    // runs the method when the button is tapped
                                    Button(action: calculateBedTime) {
                                        Text("Calculate")
                                    })
        }
    }
    
    func calculateBedTime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
