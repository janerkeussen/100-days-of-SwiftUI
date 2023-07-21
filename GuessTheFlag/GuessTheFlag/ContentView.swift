//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zhanerke Ussen on 20/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var taps = 0
    @State private var alertButtonTitle = "Continue"
    @State private var isGameOver = false
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                Text("Guess the flag").font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Text("Score: \(score)").foregroundColor(.white).font(.title.bold())
                Spacer()
                VStack(spacing: 15) {
                    VStack() {
                        Text("Tap the flag of").foregroundStyle(.secondary).font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .alert(scoreTitle, isPresented: $showingScore) {
                        Button(alertButtonTitle, action: askQuestion)
                    } message: {
                        Text(scoreMessage)
                    }
                    .alert(scoreTitle, isPresented: $isGameOver) {
                        Button(alertButtonTitle, action: reset)
                    } message: {
                        Text(scoreMessage)
                    }
                Spacer()
            }.padding()
            
        }
    }
    
    func flagTapped(_ number: Int) {
        taps += 1
        if taps < 3 {
            if number == correctAnswer {
                scoreTitle = "Correct"
                score += 1
                scoreMessage = "Your score is \(score)"
            } else {
                scoreTitle = "Wrong"
                scoreMessage = "Wrong! That’s the flag of \(countries[number])"
                score = score == 0 ? 0 : score - 1
            }
            showingScore = true
        } else {
            score = number == correctAnswer ? score + 1 : score - 1
            scoreTitle = "Game Over"
            scoreMessage = "Your final score is \(score)"
            alertButtonTitle = "Restart"
            isGameOver = true
        }
    }
    
    func reset() {
        taps = 0
        score = 0
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
