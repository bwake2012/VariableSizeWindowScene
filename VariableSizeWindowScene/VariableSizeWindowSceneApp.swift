// VariableSizeWindowSceneApp.swift
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

public let longSide: CGFloat = 720
public let shortSide: CGFloat = 360

@main
struct VariableSizeWindowSceneApp: App {
    
    @StateObject var windowInfo = WindowInfo(width: longSide, height: shortSide)
    
    var body: some Scene {
        WindowGroup {
            ContentView(passedSize: windowInfo.contentSize)
                .environmentObject(windowInfo)
                .frame(
                    minWidth: windowInfo.contentSize.width,
                    maxWidth: windowInfo.contentSize.width,
                    minHeight: windowInfo.contentSize.height,
                    maxHeight: windowInfo.contentSize.height
                )
                .background(.cyan)
        }
        .windowResizability(.contentSize)
    }
}
