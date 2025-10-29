//
//  PressableVieww.swift
//  GestosEmSwiftUI
//
//  Created by Gabriel Vicentin Negro on 17/06/25.
//

import Foundation
import SwiftUI

struct GesturePressableModifier: ViewModifier {
    @State private var isPressed: Bool = false
    let color: Color
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay {
                color.opacity(isPressed ? 0.4 : 0)
                    .mask(content)
                    .disabled(true)
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    isPressed = false
                    action()
                }.simultaneously(with: DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    })
            )
    }
}

extension View {
    public func gesturePressableView(color: Color, action: @escaping () -> Void) -> some View {
        self.modifier(GesturePressableModifier(color: color, action: action))
    }
}
