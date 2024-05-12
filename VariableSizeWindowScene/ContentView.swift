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

struct ContentView: View {
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @EnvironmentObject var windowInfo: WindowInfo

    let passedSize: CGSize
    @State var fittedSize: CGSize = .zero
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    GeometryDisplay(
                        supportsMultipleWindows: supportsMultipleWindows,
                        passedSize: passedSize,
                        geometrySize: geometry.size,
                        contentSize: windowInfo.contentSize,
                        fittedSize: fittedSize
                    )
                    .padding()
                    .background(
                        // Use geometryProxy to get childView space information here.
                        GeometryReader { geometryProxy in
                            Color.white
                                .onAppear {
                                    self.fittedSize = geometryProxy.size
                                }
                        }
                    )

                    Spacer()
                }
                Spacer()
            }
        }
        .fixedSize(horizontal: false, vertical: false)
        .glassBackgroundEffect()
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(attachmentAnchor),
            contentAlignment: contentAlignment
        ) {
            ButtonStack(attachment: attachmentAnchor) {
                PortraitButton()
                SmallSquareButton()
                LandscapeButton()
                LargeSquareButton()
                CustomSizeButton(customSize: fittedSize)
            }
            .padding()
            .glassBackgroundEffect()
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(secondaryAttachmentAnchor),
            contentAlignment: secondaryAlignment
        ) {
            ButtonStack(attachment: secondaryAttachmentAnchor) {
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .topLeading)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .top)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .topTrailing)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .leading)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .center)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .trailing)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .bottomLeading)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .bottom)
                UnitPointButton(attachmentAnchor: $attachmentAnchor, unitPoint: .bottomTrailing)
            }
            .padding()
            .glassBackgroundEffect()
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(tertiaryAttachmentAnchor),
            contentAlignment: tertiaryAlignment
        ) {
            ButtonStack(attachment: tertiaryAttachmentAnchor) {
                Text(String(format: "%3.0f", passedSize.width))
                Text(String(format: "%3.0f", passedSize.height))
            }
            .padding()
            .glassBackgroundEffect()
        }
    }

    var placement: ToolbarItemPlacement = {
        #if os(visionOS)
        return .bottomOrnament
        #else
        return .primaryAction
        #endif
    }()

    @State var attachmentAnchor: UnitPoint = .bottom

    var contentAlignment: Alignment {
        return alignment(anchor: attachmentAnchor)
    }

    var secondaryAttachmentAnchor: UnitPoint {
        if [.topLeading, .top, .topTrailing].contains(attachmentAnchor) {
            return .bottom
        } else if .leading == attachmentAnchor {
            return .trailing
        } else if [.bottomLeading, .bottom, .bottomTrailing].contains(attachmentAnchor) {
            return .top
        } else {
            return .leading
        }
    }

    var secondaryAlignment: Alignment {
        return alignment(anchor: secondaryAttachmentAnchor)
    }

    func alignment(anchor: UnitPoint) -> Alignment {
        if [.topLeading, .top, .topTrailing].contains(anchor) {
            return .bottom
        } else if .leading == anchor {
            return .trailing
        } else if [.bottomLeading, .bottom, .bottomTrailing].contains(anchor) {
            return .top
        } else if .trailing == anchor {
            return .leading
        } else {
            return .center
        }
    }

    var tertiaryAttachmentAnchor: UnitPoint {
        let anchor = attachmentAnchor
        switch attachmentAnchor {
        case .topLeading, .top, .topTrailing,
            .bottomLeading, .bottom, .bottomTrailing:
            return .leading
        case .leading, .trailing:
            return .bottom
        default:
            return .bottom
        }
    }

    var tertiaryAlignment: Alignment {
        alignment(anchor: tertiaryAttachmentAnchor)
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

struct SmallSquareButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    var body: some View {
        Button("Small Square", systemImage: "square.fill") {
            self.windowInfo.contentSize =
                CGSize(width: shortSide, height: shortSide)
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

struct LargeSquareButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    var body: some View {
        Button("Large Square", systemImage: "square.fill") {
            self.windowInfo.contentSize =
                CGSize(width: longSide, height: longSide)
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

struct CustomSizeButton: View {
    @EnvironmentObject var windowInfo: WindowInfo

    let customSize: CGSize
    var body: some View {
        Button(String(format: "%3.0f,%3.0f", customSize.width, customSize.height), systemImage: "square.fill") {
            self.windowInfo.contentSize = customSize
            windowInfo.resizeScene(newSize: self.windowInfo.contentSize)
        }
    }
}

struct ButtonStack<Content: View>: View {
    let attachment: UnitPoint
    let content: Content

    init(attachment: UnitPoint, @ViewBuilder content: () -> Content) {
        self.attachment = attachment
        self.content = content()
    }

    var body: some View {
        if horizontalAttachments.contains(attachment) {
            HStack {
                self.content
            }
        } else {
            VStack {
                self.content
            }
        }
    }

    private let horizontalAttachments: [UnitPoint] = [
        .topLeading, .top, .topTrailing, .bottomLeading, .bottom, .bottomTrailing
    ]
}

struct UnitPointButton: View {
    @Binding var attachmentAnchor: UnitPoint
    let unitPoint: UnitPoint

    var body: some View {
        Button(unitPoint.description) {
            attachmentAnchor = unitPoint
        }
    }
}

struct GeometryDisplay: View {
    let supportsMultipleWindows: Bool
    let passedSize: CGSize
    let geometrySize: CGSize
    let contentSize: CGSize
    let fittedSize: CGSize
    var body: some View {
        VStack {
            Text("Supports Multiple Windows: \(supportsMultipleWindows ? "YES" : "NO")")
                .foregroundColor(.black)

            SizeDisplay(label: "Passed:", size: passedSize)
            .background(.blue)

            SizeDisplay(label: "Geometry:", size: geometrySize)
            .background(.red)

            SizeDisplay(label: "WindowInfo:", size: contentSize)
            .background(.green)

            SizeDisplay(label: "Background:", size: fittedSize)
            .background(.black)
        }
    }
}

struct SizeDisplay: View {
    let label: String
    let size: CGSize

    var body: some View {
        HStack(alignment: .center) {
            Text("Background:")
            Text("\(Int(size.width))")
            Text("\(Int(size.height))")
        }
    }
}

extension UnitPoint {
    var description: String {
        switch self {
        case .topLeading: return "topLeading"
        case .top: return "top"
        case .topTrailing: return "topTrailing"
        case .leading: return "leading"
        case .center: return "center"
        case .trailing: return "trailing"
        case .bottomLeading: return "bottomLeading"
        case .bottom: return "bottom"
        case .bottomTrailing: return "bottomTrailing"
        default: return "\(self.x),\(self.y)"
        }
    }
}
