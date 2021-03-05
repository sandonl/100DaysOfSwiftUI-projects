//
//  ContentView.swift
//  multiply
//
//  Created by Sandon Lai on 5/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentMultiply = 0
    
    @State private var userAnswer = ""
    
    @State private var isCorrect = false
    
    
    var body: some View {
        NavigationView{
            
            ZStack {
                // Background Colour and Background Elements
                Color(red: 138/255, green: 194/255, blue: 255/255)
            
                Circle()
                    .foregroundColor(Color.init(red: 128/255, green: 181/255, blue: 237/255))
                    .frame(width: 300, height: 300)
                    .offset(x: 80, y: 210)
                    
                
                Rectangle()
                    .foregroundColor(Color(red: 109/255, green: 171/255, blue: 237/255))
                    .frame(width: 300, height: 500)
                    .rotationEffect(Angle(degrees: 80))
                    .offset(y: 350)
                
                
                
                VStack {
                    
                    Text("Multiply!")
                    
                    // Choose current multiply number.
                    Stepper("Current number:", value: $currentMultiply, in: 0...9)
                        .labelsHidden()
                    
                    // Text to display current multiply number.
                    Text("Current Multiplication table: \(currentMultiply)")
                    
                    // Text Answer for the user
                    TextField("Enter your answer!", text: $userAnswer)
                    
                    HStack{
                        
                        // Runs Check answer.
                        Button("Submit!") {
                            
                        }
                    }
                }
            }
            .navigationTitle("Multiply!")
            .ignoresSafeArea()
        }
    }
}

// Checks the answer given by the user 
func checkAnswer () {
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
