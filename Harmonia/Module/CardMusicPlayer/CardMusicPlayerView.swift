//
//  CardMusicPlayerView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI
import AVKit

struct MusicPlayerView: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 16) {
                
                VStack(spacing: 8) {
                    Slider(value: $viewModel.currentTime, in: 0...viewModel.duration, onEditingChanged: viewModel.sliderChanged)
                    
                    HStack {
                        Text(viewModel.formatTime(viewModel.currentTime))
                        Spacer()
                        Text(viewModel.formatTime(viewModel.duration))
                    }
                    .padding(.horizontal)
                }
                
                HStack(alignment: .center) {
                    HStack {
                        Slider(value: Binding(
                            get: { Double(viewModel.volume) },
                            set: { newValue in
                                viewModel.volume = Float(newValue)
                                viewModel.player.volume = viewModel.volume
                            }
                        ), in: 0...1)
                        .frame(width: 80)
                        
                        Image(systemName: "speaker.wave.1.fill").font(.title3)
                            .foregroundColor(.blue)
                        
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    HStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            viewModel.onTapPrevTrack?()
                        }) {
                            Image(systemName: "backward.fill").font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: viewModel.seekBackward) {
                            Image(systemName: "gobackward.10").font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: viewModel.togglePlayPause) {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill").font(.largeTitle)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: viewModel.seekForward) {
                            Image(systemName: "goforward.10").font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            viewModel.onTapNextTrack?()
                        }) {
                            Image(systemName: "forward.fill").font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView("Loading Audio...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.25))
            }
        }
        .frame(height: 180)
        .background(Color.gray.opacity(0.1))
    }
}
