// ContentView.swift
//
// Created by Bob Wakefield on 2/11/24.
// for VariableSizeWindowScene
//
// Using Swift 5.0
// Running on macOS 14.2
//
// 
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
