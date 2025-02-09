//
//  SongItemView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI

struct SongItemView: View {
    var songItem: SongItemResponse?
    var playerState: SpectrumVisualizerView.VisualizerState = .stopped
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: songItem?.artworkUrl100 ?? "")) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                case .failure:
                    Image(systemName: "rectangle.slash")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(songItem?.trackName ?? "-")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(songItem?.artistName ?? "")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.accentColor)
                    .lineLimit(2)
                
                Text(songItem?.collectionName ?? "")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            SpectrumVisualizerView(state: playerState, width: 20, height: 60)
                .preferredColorScheme(.light)
        }
    }
}

struct SongItemViewShimmer: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .shimmer()
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 30)
                .shimmer()
        }
    }
}

