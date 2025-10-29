//
//  ButtonInsideButton.swift
//  GestosEmSwiftUI
//
//  Created by Gabriel Vicentin Negro on 17/06/25.
//

import SwiftUI

struct ButtonInsideButton: View {
    
    @State var insideButtonCount = 0
    @State var outsideButtonCount = 0
    @State var solutions: [Solutions] = [.gestures, .button]
    @State var insideButtonSelectedSolution: Solutions = .gestures
    @State var outsideButtonSelectedSolution: Solutions = .gestures
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
    @StateObject var carouselManger = CarouselManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                
                Text("Choose the solution to use:")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                Text("External Button:")
                Picker("", selection: $outsideButtonSelectedSolution) {
                    ForEach(solutions, id: \.self) { solution in
                        Text(solution.value)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("Internal Button:")
                Picker("", selection: $insideButtonSelectedSolution) {
                    ForEach(solutions, id: \.self) { solution in
                        Text(solution.value)
                    }
                }
                .pickerStyle(.segmented)
                
                Button {
                    if #available(iOS 18, *) {
                        insideButtonSelectedSolution = .button
                        outsideButtonSelectedSolution = .button
                        
                        if carouselOn {
                            selectedSimulOrHigh = .uiGesture
                            minimumDistance = 0
                        }
                    } else {
                        insideButtonSelectedSolution = .gestures
                        outsideButtonSelectedSolution = .button
                        
                        if carouselOn {
                            selectedSimulOrHigh = .simul
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
                    Button("Reset count") {
                        outsideButtonCount = 0
                        insideButtonCount = 0
                    }
                }
                ScrollView(showsIndicators: true) {
                    if carouselOn {
                        Carousel(manager: carouselManger,
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
                            if selectedSimulOrHigh != .uiGesture {
                                VStack(alignment: .leading) {
                                    Text(String(format: "Minimum Distance: %.0f", minimumDistance))
                                    Slider(value: $minimumDistance, in: 0...100)
                                }
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
                    Text("External Button Taps:")
                    Text("\(outsideButtonCount)")
                        .bold()
                        .foregroundStyle(.red)
                }
                HStack {
                    Text("Internal Button Taps:")
                    Text("\(insideButtonCount)")
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
        HStack {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 40)
                    .foregroundStyle(.brown)
                    .padding()
                    .if(insideButtonSelectedSolution == .gestures, { view in
                        view.gesturePressableView(color: .gray) {
                            insideButtonCount += 1
                        }
                    })
                    .if(insideButtonSelectedSolution == .button, { view in
                        view.buttonPressableView(color: .gray) {
                            insideButtonCount += 1
                        }
                    })
            }
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.black))
            .if(outsideButtonSelectedSolution == .gestures, { view in
                view.gesturePressableView(color: .gray) {
                    outsideButtonCount += 1
                }
            })
            .if(outsideButtonSelectedSolution == .button, { view in
                view.buttonPressableView(color: .gray) {
                    outsideButtonCount += 1
                }
            })
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ButtonInsideButton()
}

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, @ViewBuilder _ transform: (Self) -> (some View)) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
