//
//  ContentView.swift
//  GameSceneManager
//
//  Created by Praveen Jangre on 11/07/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            startGameScene()
        }
    }
}

#Preview {
    ContentView()
}
