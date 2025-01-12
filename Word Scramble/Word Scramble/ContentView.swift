//
//  ContentView.swift
//  Word Scramble
//
//  Created by Zhanerke Ussen on 12/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var isAlertPresented = false
    @State private var errorTitle = "Try again"
    @State private var errorMessage = ""
    @State private var score = 0
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Score \(score)")
            List {
                Section("New word") {
                    TextField("Enter your word", text: $newWord)
                        .onSubmit {
                            add()
                        }
                        .textInputAutocapitalization(.never)
                }
                
                Section("Used words") {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(rootWord)
            .onAppear(perform: pickAword)
            .alert(errorTitle, isPresented: $isAlertPresented) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart") { pickAword() }
                    .padding(8)
            }
            
        }
        }
    }
    
    private func add() {
        let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard word.count > 0 else { return }
        
        guard word.count > 2 else {
            showError(messaage: "Too short")
            return
        }
        
        guard rootWord != word else {
            showError(messaage: "Can't use that word")
            return
        }
        
        guard isOriginal(word) else {
            showError(messaage: "Already used!")
            return
        }
        guard isPossible(word) else  {
            showError(messaage:  "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word) else {
            showError(messaage: "Not a real word")
            return
        }
        withAnimation(.easeIn) {
            usedWords.insert(word, at: 0)
            score += 1
        }
        newWord = ""
    }
    
    private func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isPossible(_ word: String) -> Bool {
        var temp = rootWord
        
        for letter in word {
            if let position = temp.firstIndex(of: letter) {
                temp.remove(at: position)
            }  else {
                return false
            }
        }
        return true
    }
    
    private func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelled = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelled.location == NSNotFound
    }
    
    private func showError(messaage: String) {
        errorMessage = messaage
        isAlertPresented = true
    }
    
    private func pickAword() {
        guard let wordsFileUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let words = try? String(contentsOf: wordsFileUrl).components(separatedBy: "\n") else {
            fatalError("Could load the file from bundle")
        }
        rootWord = words.randomElement() ?? "Christmas"
        usedWords = []
        score = 0
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
