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
