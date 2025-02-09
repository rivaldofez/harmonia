//
//  HomeViewModel.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    var provider = NetworkProvider<HomeTarget>()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchQuery: String
    @Published var viewState: ViewState
    @Published var errorMessage: String?
    @Published var songList: [SongItemResponse]
    @Published var selectedSong: SongItemResponse?
    @Published var musicViewModel: MusicPlayerViewModel!
    
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>(), searchQuery: String = "", viewState: ViewState = .loading, errorMessage: String? = nil, songList: [SongItemResponse] = []) {
        
        self.cancellables = cancellables
        self.searchQuery = searchQuery
        self.viewState = viewState
        self.errorMessage = errorMessage
        self.songList = songList
        self.musicViewModel = MusicPlayerViewModel(
                    onTapNextTrack: { [weak self] in self?.onTapNextTrack() },
                    onTapPrevTrack: { [weak self] in self?.onTapPrevTrack() })
        
        fetchSong(query: "Bruno Mars")
    }
    
    func onTapNextTrack() {
        guard let currentIndex = songList.firstIndex(where: { $0 == selectedSong }) else {
            if !songList.isEmpty {
                selectSong(selectedSong: songList[0])
            }
            return
        }
        
        if currentIndex < songList.count - 1 {
            selectSong(selectedSong: songList[currentIndex + 1])
        }
    }
    
    func onTapPrevTrack() {
        guard let currentIndex = songList.firstIndex(where: { $0 == selectedSong }) else {
            if !songList.isEmpty {
                selectSong(selectedSong: songList[0])
            }
            return
        }
        
        if currentIndex > 0 {
            selectSong(selectedSong: songList[currentIndex - 1])
        }
    }
    
    func fetchSong(query: String) {
        viewState = .loading
        provider.requestPlainResponse(.searchForSong(query: query))
            .decodeJSON(to: SongResponse.self)
            .receive(on: RunLoop.main)
            .sink { result in
                switch(result){
                case .success(let response):
                    self.viewState = .success
                    self.songList = response.results ?? []
                case .failure(let error):
                    self.viewState = .error(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    func selectSong(selectedSong: SongItemResponse) {
        self.selectedSong = selectedSong
        musicViewModel.setupPlayer(url: selectedSong.previewURL ?? "")
        
    }
}
