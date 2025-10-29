import SwiftUI
import Combine

@MainActor
final class CarouselManager: ObservableObject {
    // MARK: - Published Properties
    @Published var dragOffset: CGFloat = 0
    @Published var currentIndex: Int = 0

    // MARK: - Properties
    var itemsCount: Int = 0
    var currentItemWidth: CGFloat = 0

    private var currentItemOffset: CGFloat {
        (-CGFloat(currentIndex) * currentItemWidth)
    }

    var calculatedOffset: CGFloat {
        currentItemOffset + dragOffset
    }

    // MARK: - Initialization
    init() { }
    
    // MARK: - Public Methods
    func handleDragGesture(_ value: DragGesture.Value) {
        withAnimation(.linear(duration: 0)) {
            dragOffset = value.translation.width
        }
    }

    func handleDragGestureEnd(_ value: DragGesture.Value) {
        withAnimation(.bouncy) {
            currentIndex = getFinalIndexFromGestureEnd(value)
            dragOffset = 0
        }
    }

    func getFinalIndexFromGestureEnd(_ value: DragGesture.Value) -> Int {
        calculateIndexOnGestureEnd(value)
    }
    
    // MARK: - Custom UIKit Gesture Methods
    func handleCustomDragGesture(_ value: CustomDragValue) {
        withAnimation(.linear(duration: 0)) {
            dragOffset = value.translation.width
        }
    }

    func handleCustomDragGestureEnd(_ value: CustomDragValue) {
        withAnimation(.bouncy) {
            currentIndex = getCustomFinalIndexFromGestureEnd(value)
            dragOffset = 0
        }
    }

    func getCustomFinalIndexFromGestureEnd(_ value: CustomDragValue) -> Int {
        calculateCustomIndexOnGestureEnd(value)
    }

    // MARK: - Private Methods
    private func calculateIndexOnGestureEnd(_ value: DragGesture.Value) -> Int {
        let predictedEndOffset = value.predictedEndTranslation.width + currentItemOffset
        let velocityThreshold: CGFloat = 100

        var newIndex = currentIndex

        if abs(value.predictedEndTranslation.width - value.translation.width) > velocityThreshold {
            if value.predictedEndTranslation.width < value.translation.width {
                newIndex = min(currentIndex + 1, itemsCount - 1)
            } else {
                newIndex = max(currentIndex - 1, 0)
            }
        } else {
            let targetOffset = -predictedEndOffset / (currentItemWidth)
            newIndex = min(max(Int(round(targetOffset)), 0), itemsCount - 1)
        }

        return newIndex
    }
    
    private func calculateCustomIndexOnGestureEnd(_ value: CustomDragValue) -> Int {
        let predictedEndOffset = value.predictedEndTranslation.width + currentItemOffset
        let velocityThreshold: CGFloat = 100

        var newIndex = currentIndex

        if abs(value.predictedEndTranslation.width - value.translation.width) > velocityThreshold {
            if value.predictedEndTranslation.width < value.translation.width {
                newIndex = min(currentIndex + 1, itemsCount - 1)
            } else {
                newIndex = max(currentIndex - 1, 0)
            }
        } else {
            let targetOffset = -predictedEndOffset / (currentItemWidth)
            newIndex = min(max(Int(round(targetOffset)), 0), itemsCount - 1)
        }

        return newIndex
    }
}
