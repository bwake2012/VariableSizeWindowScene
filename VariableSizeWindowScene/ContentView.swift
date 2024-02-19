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
    @EnvironmentObject var windowInfo: WindowInfo

    let passedSize: CGSize
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack {

                        HStack(alignment: .center) {
                            Text("PassedSize:")
                            Text("\(Int(passedSize.width))")
                            Text("\(Int(passedSize.height))")
                        }
                        .background(.blue)

                        HStack(alignment: .center) {
                            Text("Geometry:")
                            Text("\(Int(geometry.size.width))")
                            Text("\(Int(geometry.size.height))")
                        }
                        .background(.red)

                        HStack(alignment: .center) {
                            Text("WindowInfo:")
                            Text("\(Int(windowInfo.contentSize.width))")
                            Text("\(Int(windowInfo.contentSize.height))")
                        }
                        .background(.green)

                        VStack(alignment: .center) {
                            PortraitButton()
                            SquareButton()
                            LandscapeButton()
                        }
                    }
                    .padding()

                    Spacer()
                }
                Spacer()
            }
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}

struct PortraitButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    var body: some View {
        Button("Portrait", systemImage: "rectangle.portrait.fill") {
            self.windowInfo.contentSize =
            CGSize(width: shortSide, height: longSide)
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

struct LandscapeButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    var body: some View {
        Button("Landscape", systemImage: "rectangle.fill") {
            self.windowInfo.contentSize =
            CGSize(width: longSide, height: shortSide)
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

struct SquareButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    var body: some View {
        Button("Square", systemImage: "square.fill") {
            self.windowInfo.contentSize =
            CGSize(width: shortSide, height: shortSide)
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

