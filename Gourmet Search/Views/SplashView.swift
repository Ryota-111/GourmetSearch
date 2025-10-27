//
//  SplashView.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/18.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @Binding var isPresented: Bool
    
    // MARK: - body
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.orange,
                    Color.red,
                    Color.orange
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 10) {
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        .frame(width: 160, height: 160)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0 : 1)

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)

                    Image(systemName: "fork.knife")
                        .font(.system(size: 56, weight: .semibold))
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees(isAnimating ? 0 : -180))
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                }

                VStack(spacing: 10) {
                    Text("グルメサーチ")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)

                    Text("レストラン検索")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }

                Spacer()

                VStack(spacing: 10) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)

                    Text("読み込み中...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(showContent ? 1 : 0)
                .padding(.bottom, 10)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    // MARK: - Animations
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            isAnimating = true
        }

        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
            isAnimating = true
        }

        withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
            showContent = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                isPresented = false
            }
        }
    }
}

#Preview {
    SplashView(isPresented: .constant(true))
}
