// WindowInfo.swift
//
// Created by Bob Wakefield on 2/11/24.
// for VariableSizeWindowScene
//
// Using Swift 5.0
// Running on macOS 14.2
//
// 
//

import UIKit

class WindowInfo: ObservableObject {

    @Published var contentSize: CGSize {
        didSet {
            print("contentSize:\(contentSize.width),\(contentSize.height)")
        }
    }

    func resizeScene(newSize: CGSize) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let geometryRequest = UIWindowScene.GeometryPreferences.Vision(
            size: newSize
        )

        windowScene.requestGeometryUpdate(geometryRequest)
    }

    init(width: CGFloat, height: CGFloat) {
        self.contentSize = CGSize(width: width, height: height)
    }
}

