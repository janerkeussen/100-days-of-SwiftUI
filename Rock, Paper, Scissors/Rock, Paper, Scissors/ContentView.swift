//
//  ContentView.swift
//  Rock, Paper, Scissors
//
//  Created by Zhanerke Ussen on 02/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var moves = ["🪨", "📜", "✂️"]
    @State private var appSelectedMove = "🪨"
    @State private var userSelectedMove = ""
    @State private var win = true
    @State private var score = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .orange], startPoint: .leading, endPoint: .bottom)
            VStack {
                Text("Score: \(score)")
                    .padding(.leading, 250)
                    .padding(.top, 50)
                Spacer()
                Text("App's move:  \(appSelectedMove)")
                    .font(.title2)
                    .padding(25)
                Text("Your move to \(win ? "win" : "loose"):")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(win ? .green : .red)
                HStack {
                    ForEach(moves, id: \.self) { move in
                        Button("\(move)") {
                            userSelectedMove = move
                            if Judge(yourMove: userSelectedMove,
                                     appMove: appSelectedMove).didIWin() {
                                score += 1
                            } else {
                                score = score > 0 ? score - 1 : 0
                            }
                            win.toggle()
                            appSelectedMove = moves[Int.random(in: 0..<3)]
                        }
                        .font(.largeTitle)
                        .padding(10)
                    }
                }
                Spacer()
            }.padding()
            
        }.ignoresSafeArea()
    }
}

struct Judge {
    var yourMove: String
    var appMove: String
    
    func didIWin() -> Bool {
        if yourMove == appMove {
            return false
        }
        
        if yourMove == "🪨" && appMove == "✂️" {
            return true
        }
        
        if yourMove == "✂️" && appMove == "📜" {
            return true
        }
        
        if yourMove == "📜" && appMove == "🪨" {
            return true
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
