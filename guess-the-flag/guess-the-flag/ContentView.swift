//
//  ContentView.swift
//  guess-the-flag
//
//  Created by Sandon Lai on 25/2/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false // boolean for alert
    @State private var scoreTitle = ""
    @State private var userScore = 0    
    @State private var scoreMessage = ""
    
    // MARK: - Challenge State variables
    @State private var correctFlag = false
    @State private var selectedNumber = 0
    @State private var fadeOutFlag = false
    @State private var wrongFlag = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach (0..<3) { number in
                    Button(action: {
                        withAnimation{
                            self.flagTapped(number)
                        }
                    }) {
                        FlagImage(image: self.countries[number])
                    }
                    // correct flag selections flips the flag horizontally.
                    .rotation3DEffect(.degrees(self.correctFlag && self.selectedNumber == number ? 360 : 0), axis:(x: 0, y: 1, z: 0))
                    // fades out non-correct flags
                    .opacity(self.fadeOutFlag && self.selectedNumber != number ? 0.25 : 1)
                    // wrong flag selections flips the flag awkwardly.
                    .rotation3DEffect(.degrees(self.wrongFlag && self.selectedNumber == number ? 360 : 0), axis: (x: 1, y: 1, z: 0))

                    
                }
                Text("Current Score: \(userScore)")
                    .BlueTitle()
//                    .foregroundColor(.white)
//                    .font(.headline)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                  })
        }
    }
    
    func flagTapped (_ number: Int) {
        self.selectedNumber = number
        if number == correctAnswer {
            correctFlag = true
            fadeOutFlag = true
            scoreTitle = "Correct"
            userScore += 1
            scoreMessage = "You got it right!"
        } else {
            wrongFlag = true
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! that's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctFlag = false
        fadeOutFlag = false
        wrongFlag = false
    }
}

// MARK: - Challenge to add View of 'FlagImage'

struct FlagImage: View {
    let image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 3))
            .shadow(color: .black, radius: 2)
    }
}

// MARK: - Challenge to add a custom ViewModifier (and accompanying View extension)
// Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view

struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(20)
            
    }
}

// Now add the extension
extension View {
    func BlueTitle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
