//
//  ContentView.swift
//  GestosEmSwiftUI
//
//  Created by Gabriel Vicentin Negro on 17/06/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink {
                        ButtonsOnScrollView()
                    } label: {
                        Text("A Button on a Scroll View")
                    }
                    NavigationLink {
                        ButtonInsideButton()
                    } label: {
                        Text("A button inside another Button on a Scroll View")
                    }
                }
            }
            .navigationTitle("You're in iOS \(UIDevice.current.systemVersion)")
        }
    }
}

#Preview {
    ContentView()
}
