//
//  ContentView.swift
//  multiply
//
//  Created by Sandon Lai on 5/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameIsActive = false
    
    @State private var resultAlert = false
    
    @State private var questions = [Question]()
    
   
    
    @State private var chosenMultiple = 2
    
    @State private var userSelectQuestions = ""
    
    @State private var currentQuestion = ""
    
    @State private var currentAnswer = ""
    
    @State private var userAnswer = ""
    
    // Alert properties
    @State private var alertMessage = ""
    
    @State private var alertTitle = ""
    
    var numberOfQuestions = ["5", "10", "15", "20", "All"]
    
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
                
                Group {
                    if !gameIsActive {
                        VStack {
                            Section {
                                // Text to display current multiply number.
                                Text("Practice which table?:  \(chosenMultiple)")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                
                                Stepper("Current number:", value: $chosenMultiple, in: 2...12)
                                    .labelsHidden()
                            }
                            
                            Section {
                                Text("How many questions?")
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                
                                Picker("Number of questions", selection: $userSelectQuestions) {
                                    ForEach(numberOfQuestions, id: \.self) {
                                        Text($0)
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                .colorInvert()
                                
                                Button(action: {
                                    generateQuestions(currentMultiple: chosenMultiple, numberOfQuestions: userSelectQuestions)
                                    gameIsActive = true
                                    displayQuestion()

                                }) {
                                    Text("Start Game")
                                        // MARK: TODO: - Can turn this into a view
                                        .padding()
                                        .background(Color.init(red: 255/255, green: 182/255, blue: 79/255))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                        .font(.subheadline)
                                }
                            }
                            
                        }
                    } else {
                        VStack {
                            
                            Text(currentQuestion)

                            TextField("Enter your answer!", text: $userAnswer)
                                .frame(width: 200, height: 200)
                            
                            Button(action: {
                                // runs checkAnswer
                                checkAnswer()
                                displayQuestion()
                            }) {
                                Text("Guess!")
                                    .padding()
                                    .background(Color.init(red: 255/255, green: 182/255, blue: 79/255))
                                    .cornerRadius(20)
                                    .font(.subheadline)
                            }
                        }
                    }
                }

            }
            .navigationTitle("Multiply!")
            .ignoresSafeArea()
        }
    }
    
    // Generates the questions to be used
    func generateQuestions(currentMultiple: Int, numberOfQuestions: String) {
        
        var numberToGenerate = 0
                
        switch numberOfQuestions {
        case "All":
            numberToGenerate = 30
        default:
            numberToGenerate = Int(numberOfQuestions) ?? 5
        }
        
        for _ in 1...numberToGenerate {
            // MARK: TODO - Mght be duplicate questions
            let i = Int.random(in: 1...12)
            
            questions.append(Question(question: "What is \(currentMultiple) x \(i) = ?", answer: String(currentMultiple*i)))
        }

    }
    
    
    func displayQuestion() {
        
        guard !questions.isEmpty else {
            gameIsActive = false
            return
        }
        
        currentQuestion = questions.last?.question ?? "Error."
        currentAnswer = questions.last?.answer ?? "Error."
        
        questions.removeLast()
        
    }
    
    func checkAnswer() {
        
        if userAnswer == currentAnswer {
            alertMessage = "Correct! Good Job"
        }
        
        
        
    }
    
    
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
