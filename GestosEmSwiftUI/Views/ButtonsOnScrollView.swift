//
//  ButtonWithGestures.swift
//  GestosEmSwiftUI
//
//  Created by Gabriel Vicentin Negro on 17/06/25.
//

import SwiftUI

struct ButtonsOnScrollView: View {
    
    @State var count = 0
    @State var solutions: [Solutions] = [.gestures, .button]
    @State var selectedSolution: Solutions = .gestures
    @State var carouselSolutions: [SimulOrHigh] = {
        if #available(iOS 18.0, *) {
            return [.high, .simul, .gesture, .uiGesture]
        } else {
            return [.high, .simul, .gesture]
        }
    }()
    @State var selectedSimulOrHigh: SimulOrHigh = .simul
    @State var carouselOn = false
    @State var minimumDistance: CGFloat = 0
    @StateObject var carouselManager = CarouselManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Choose the solution to use:")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                Picker("", selection: $selectedSolution) {
                    ForEach(solutions, id: \.self) { solution in
                        Text(solution.value)
                    }
                }
                .pickerStyle(.segmented)
                
                Button {
                    if #available(iOS 18, *) {
                        selectedSolution = .gestures
                        
                        if carouselOn {
                            selectedSimulOrHigh = .uiGesture
                            minimumDistance = 0
                        }
                    } else {
                        selectedSolution = .button
                        
                        if carouselOn {
                            selectedSimulOrHigh = .high
                            minimumDistance = 20
                        }
                    }
                } label: {
                    Text("Recomended Solution")
                }
                .font(.subheadline)
            }
            .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("ScrollView:")
                    Spacer()
                    Button("Reset") {
                        count = 0
                    }
                }
                ScrollView(showsIndicators: true) {
                    if carouselOn {
                        Carousel(manager: carouselManager,
                                        simulOrHigh: $selectedSimulOrHigh,
                                        minimumDistance: $minimumDistance,
                                        [
                                            MyButton(),
                                            MyButton()
                                        ])
                    } else {
                        MyButton()
                    }
                    VStack {
                        Toggle(isOn: $carouselOn) {
                            Text("Carousel")
                        }
                        if carouselOn {
                            HStack {
                                Text("Solution:")
                                Spacer()
                                Picker("", selection: $selectedSimulOrHigh) {
                                    ForEach(carouselSolutions, id: \.self) { solution in
                                        Text(solution.value)
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(String(format: "Minimum Distance: %.0f", minimumDistance))
                                Slider(value: $minimumDistance, in: 0...100)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 300)
                .background(RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.regularMaterial)
                )
                .clipped()
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Button Taps:")
                    Text("\(count)")
                        .bold()
                        .foregroundStyle(.red)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func MyButton() -> some View {
        Group {
            if selectedSolution == .gestures {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .gesturePressableView(color: .gray) {
                        count += 1
                    }
            } else if selectedSolution == .button {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .buttonPressableView(color: .gray) {
                        count += 1
                    }
            }
        }
        .padding()
    }
}

//MARK: Solutions Enum
enum Solutions: String {
    case gestures
    case button
    
    var value: String {
        switch self {
        case .gestures:
            return "Gestures"
        case .button:
            return "Button"
        }
    }
}

#Preview {
    ButtonsOnScrollView()
}
