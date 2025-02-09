//
//  HomeView.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("Search...", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        viewModel.fetchSong(query: viewModel.searchQuery)
                    }
                switch(viewModel.viewState) {
                case .error(let message):
                    ErrorView(message: message)
                case .loading:
                    List {
                        ForEach(0..<7, id: \.self) { song in
                            SongItemViewShimmer()
                        }
                    }
                    .scrollDisabled(true)
                    .listStyle(.plain)
                    .background(Color.clear.ignoresSafeArea())
                case .success:
                    if viewModel.songList.isEmpty {
                        EmptyView()
                    } else {
                        List(viewModel.songList, id: \.self, selection: $viewModel.selectedSong) { song in
                            SongItemView(songItem: song, playerState: song == viewModel.selectedSong ? .playing : .reset)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectSong(selectedSong: song)
                                    }
                                    
                                }
                        }
                        .listStyle(.plain)
                        .background(Color.clear.ignoresSafeArea())
                    }
                }
                
                if viewModel.selectedSong != nil {
                    MusicPlayerView(viewModel: viewModel.musicViewModel)
                        .ignoresSafeArea(.all)
                }
            }
            .navigationTitle("Harmonia Music Player")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    HomeView()
}
