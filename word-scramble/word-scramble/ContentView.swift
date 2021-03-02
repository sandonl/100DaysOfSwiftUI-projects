//
//  ContentView.swift
//  word-scramble
//
//  Created by Sandon Lai on 2/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var userScore = 0
    
    
    var body: some View {
    
        NavigationView {
            VStack{
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
 
                List(usedWords, id: \.self) {
                    // uses SF symbols to illustrate count of letters
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                
                Text("User Score: \(userScore)")
            }
            .navigationBarTitle(rootWord)
            
            // Lets the user restart the game to change the word
            .navigationBarItems(leading: Button("Restart Game") {
                startGame()
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                
            }

        }
    }
    
    // Starts the game
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
        
    }
    
    
    // Add new word function
    func addNewWord() {
        // lowercase and trim the word
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exits if the remaining string is empty
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognised", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        // Inserting slides the words at the top of the list.
        usedWords.insert(answer, at: 0)
        newWord = ""
        userScore += answer.count
    }
    
    // MARK: - Game Mechanics
    // Checks if the word has already been used in the list
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // Checks if the word is possible and stems from the rootword
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    // Bridge Strings from Obj-C, checks if the word is a real word using UITextChecker()
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // Checks that the word length is greater than 3 letters or is equal to the rootWord
        if word.count < 3 {
            return false
        } else if word == rootWord {
            return false
        }
        
        return misspelledRange.location == NSNotFound
    }
    
    // Provides error alert handling 
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
