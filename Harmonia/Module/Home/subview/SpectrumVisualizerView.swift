//
//  SpectrumVisualizerView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI

struct SpectrumVisualizerView: View {
    enum VisualizerState {
        case playing
        case stopped
        case reset
    }
    
    @Binding var state: VisualizerState
    @State private var barHeights: [CGFloat] = Array(repeating: 10, count: 5)
    @State private var timer: Timer? = nil
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(barHeights.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(width: width / CGFloat(barHeights.count), height: barHeights[index])
                    .animation(.easeInOut(duration: 0.2), value: barHeights[index])
            }
        }
        .frame(width: width, height: height)
        .onChange(of: state) {
            handleStateChange(state)
        }
    }
    
    private func handleStateChange(_ newState: VisualizerState) {
        switch newState {
        case .playing:
            startAnimation()
        case .stopped:
            stopAnimation()
        case .reset:
            resetAnimation()
        }
    }
    
    private func startAnimation() {
        stopAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation {
                barHeights = barHeights.map { _ in CGFloat.random(in: 10...(height / 2)) }
            }
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetAnimation() {
        stopAnimation()
        withAnimation {
            barHeights = Array(repeating: 10, count: barHeights.count)
        }
    }
}
