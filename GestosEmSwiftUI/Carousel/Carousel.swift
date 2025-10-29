import SwiftUI

struct Carousel<Content: View>: View {
    // MARK: - Properties
    @ObservedObject private var manager: CarouselManager
    @Binding var simulOrHigh: SimulOrHigh
    @Binding var minimumDistance: CGFloat

    private let items: [Content]

    // MARK: - Initialization
    init(manager: CarouselManager, simulOrHigh: Binding<SimulOrHigh>, minimumDistance: Binding<CGFloat>, _ items: [Content]) {
        self._manager = ObservedObject(wrappedValue: manager)
        _simulOrHigh = simulOrHigh
        _minimumDistance = minimumDistance
        self.items = items
    }

    var body: some View {
        container { itemWidth in
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                item
                    .frame(width: itemWidth)
            }
        }
    }
    
    @State var gestureMask: GestureMask = .all
    @ViewBuilder
    private func container(@ViewBuilder _ content: @escaping (CGFloat) -> some View) -> some View {
        if simulOrHigh == .simul {
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    content(proxy.size.width)
                }
                .offset(x: manager.calculatedOffset)
                .onAppear {
                    manager.itemsCount = items.count
                    manager.currentItemWidth = proxy.size.width
                }
            }
            .frame(height: 104)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture(minimumDistance: minimumDistance)
                .onChanged { value in
                    manager.handleDragGesture(value)
                    gestureMask = .gesture
                }
                .onEnded { value in
                    manager.handleDragGestureEnd(value)
                    gestureMask = .all
                },
                including: gestureMask
            )
            
            .clipped()
        } else if simulOrHigh == .high {
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    content(proxy.size.width)
                }
                .offset(x: manager.calculatedOffset)
                .onAppear {
                    manager.itemsCount = items.count
                    manager.currentItemWidth = proxy.size.width
                }
            }
            .frame(height: 104)
            .contentShape(Rectangle())
            .highPriorityGesture(DragGesture(minimumDistance: minimumDistance)
                .onChanged(manager.handleDragGesture)
                .onEnded(manager.handleDragGestureEnd)
            )
            .clipped()
        } else if simulOrHigh == .uiGesture {
            // Esta opção só está disponível no iOS 18+
            if #available(iOS 18.0, *) {
                GeometryReader { proxy in
                    HStack(alignment: .top, spacing: 0) {
                        content(proxy.size.width)
                    }
                    .offset(x: manager.calculatedOffset)
                    .onAppear {
                        manager.itemsCount = items.count
                        manager.currentItemWidth = proxy.size.width
                    }
                }
                .frame(height: 104)
                .contentShape(Rectangle())
                .gesture(
                    CustomDragGesture(
                        onChanged: manager.handleCustomDragGesture,
                        onEnded: manager.handleCustomDragGestureEnd
                    )
                )
                .clipped()
            }
        } else if simulOrHigh == .gesture {
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    content(proxy.size.width)
                }
                .offset(x: manager.calculatedOffset)
                .onAppear {
                    manager.itemsCount = items.count
                    manager.currentItemWidth = proxy.size.width
                }
            }
            .frame(height: 104)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: minimumDistance)
                .onChanged(manager.handleDragGesture)
                .onEnded(manager.handleDragGestureEnd)
            )
            .clipped()
        }
    }
}

enum SimulOrHigh: String {
    case simul
    case high
    case gesture
    case uiGesture
    
    var value: String {
        switch self {
        case .simul:
            return "Simultaneous Gesture"
        case .high:
            return "High Priority Gesture"
        case .gesture:
            return "Gesture"
        case .uiGesture:
            return "UIKit Gesture"
        }
    }
}




