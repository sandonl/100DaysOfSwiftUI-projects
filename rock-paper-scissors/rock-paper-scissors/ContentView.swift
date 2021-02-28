//
//  ContentView.swift
//  rock-paper-scissors
//
//  Created by Sandon Lai on 27/2/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var playerWin = Bool.random()
    @State private var playerScore = 0
    @State private var showRules = false
    
    
    var moves = ["Rock", "Paper", "Scissors"]
    
    var winningMove: String {
        switch currentChoice {
        case 0 :
            if playerWin == true {
                return "Paper"
            } else {
                return "Scissors"
            }
        case 1 :
            if playerWin == true {
                return "Scissors"
            } else {
                return "Rock"
            }
        case 2 :
            if playerWin == true {
                return "Rock"
            } else {
                return "Paper"
            }
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 140/255, green: 182/255, blue: 250/255), Color.blue]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                    VStack (spacing: 30) {
                        Text("Player Score: \(playerScore)")
                            .padding()
                            .background(Color(red: 140/255, green: 182/255, blue: 250/255))
                            .cornerRadius(20)
                        
                        Text("App's Move: \(moves[currentChoice])")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text(playerWin ? "Win" : "Lose")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(playerWin ? .green : .red)
                        
                        HStack {
                            ForEach(0..<3) { number in
                                Button(moves[number]) {
                                    playGame(choice: moves[number])
                                }
                            }
                            .padding()
                            .background(Color(red: 140/255, green: 182/255, blue: 250/255))
                            .foregroundColor(.black)
                            .cornerRadius(20)
                        }
                        Spacer()
                        
                        Button("Show Rules") {
                            showRules = true
                        }
                        .foregroundColor(.black)
                    }
                    .alert(isPresented: $showRules, content: {
                        Alert(title: Text("How to play:"), message: Text("React to the app's move by trying to achieve the given 'Win' or 'Lose' condition"), dismissButton: .default(Text("Got it!")))
                })
                
            }
            
            
        }
    }
    
    
    func playGame(choice: String) {
        if winningMove == choice {
            playerScore += 1
        }
        // then restart the game
        playerWin = Bool.random()
        currentChoice = Int.random(in: 0...2)
    }
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
