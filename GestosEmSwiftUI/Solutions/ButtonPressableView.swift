//
//  ButtonPressableVoew.swift
//  GestosEmSwiftUI
//
//  Created by Gabriel Vicentin Negro on 17/06/25.
//

import Foundation
import SwiftUI

public struct PressableButtonStyle: ButtonStyle {
    let color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                color.opacity(configuration.isPressed ? 0.4 : 0)
                    .mask(configuration.label)
                    .allowsHitTesting(false)
            }
    }
}

extension View {
    public func buttonPressableView(color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(PressableButtonStyle(color: color))
    }
}
