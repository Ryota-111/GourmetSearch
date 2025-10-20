//
//  ContentView.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            SearchView()
                .opacity(showSplash ? 0 : 1)

            if showSplash {
                SplashView(isPresented: $showSplash)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
