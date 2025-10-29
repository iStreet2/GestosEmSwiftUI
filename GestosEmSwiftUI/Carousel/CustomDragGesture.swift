import SwiftUI
import UIKit

// Custom drag value struct that mimics DragGesture.Value
struct CustomDragValue {
    let time: Date
    let location: CGPoint
    let startLocation: CGPoint
    let velocity: CGSize
    
    var translation: CGSize {
        CGSize(
            width: location.x - startLocation.x,
            height: location.y - startLocation.y
        )
    }
    
    var predictedEndTranslation: CGSize {
        CGSize(
            width: translation.width + velocity.width * 0.1,
            height: translation.height + velocity.height * 0.1
        )
    }
}

struct CustomDragGesture: UIGestureRecognizerRepresentable {
    var onChanged: (CustomDragValue) -> Void
    var onEnded: (CustomDragValue) -> Void
    var minimumDistance: CGFloat = 10.0
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = context.coordinator
        return gesture
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        print("action")
        let velocity = recognizer.velocity(in: recognizer.view)
        let location = recognizer.location(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            context.coordinator.startLocation = location
            
        case .changed:
            let dragValue = CustomDragValue(
                time: Date(),
                location: location,
                startLocation: context.coordinator.startLocation ?? location,
                velocity: CGSize(width: velocity.x, height: velocity.y)
            )
            if abs(dragValue.translation.width) >= minimumDistance || abs(dragValue.translation.height) >= minimumDistance {
                onChanged(dragValue)
            }
            
        case .ended, .cancelled:
            let dragValue = CustomDragValue(
                time: Date(),
                location: location,
                startLocation: context.coordinator.startLocation ?? location,
                velocity: CGSize(width: velocity.x, height: velocity.y)
            )
            
            onEnded(dragValue)
            context.coordinator.reset()
            
        default:
            break
        }
    }
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var startLocation: CGPoint?
        
        func reset() {
            startLocation = nil
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
                return false
            }
            
            let velocity = panGesture.velocity(in: panGesture.view)
            return abs(velocity.y) > abs(velocity.x)
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
                return true
            }
            let velocity = panGesture.velocity(in: panGesture.view)
            return abs(velocity.x) > abs(velocity.y)
        }
    }
} 
