//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Zhanerke Ussen on 21/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            Text("Grid Title")
                .blueTitle()
                .padding(12)
            ForEach(0..<columns, id: \.self) { row in
                HStack {
                    ForEach(0..<rows, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

extension View {
    func blueTitle() -> some View {
        return modifier(BlueTitle())
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
