//
//  CardMusicViewModel.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import AVKit

class MusicPlayerViewModel: ObservableObject {
    var onTapNextTrack: (() -> Void)? = nil
    var onTapPrevTrack: (() -> Void)? = nil
    
    @Published var player = AVPlayer()
    @Published var isPlaying = false
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 1.0
    @Published var volume: Float = 0.5
    @Published var isLoading = true
    
    private var observer: NSKeyValueObservation?
    
    init(onTapNextTrack: ( () -> Void)? = nil, onTapPrevTrack: ( () -> Void)? = nil, player: AVPlayer = AVPlayer(), isPlaying: Bool = false, currentTime: Double = 0.0, duration: Double = 1.0, volume: Float = 0.5) {
        self.onTapNextTrack = onTapNextTrack
        self.onTapPrevTrack = onTapPrevTrack
        self.player = player
        self.isPlaying = isPlaying
        self.currentTime = currentTime
        self.duration = duration
        self.volume = volume
    }

    func setupPlayer(url: String) {
        guard let audioURL  = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: audioURL)
        player.replaceCurrentItem(with: playerItem)
        player.volume = volume
        
        isPlaying = false
        togglePlayPause()
        

       observer = playerItem.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
           DispatchQueue.main.async {
               if item.status == .readyToPlay {
                   self?.isLoading = false
               }
           }
       }

       observer = playerItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new, .initial]) { [weak self] item, _ in
           DispatchQueue.main.async {
               self?.isLoading = !item.isPlaybackLikelyToKeepUp
           }
       }
        
        let timeObserver = CMTimeMakeWithSeconds(1, preferredTimescale: 1)
        player.addPeriodicTimeObserver(forInterval: timeObserver, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if let duration = self.player.currentItem?.duration.seconds, duration.isFinite {
                self.duration = duration
            }
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
            self?.isPlaying = false
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            if currentTime >= duration {
                player.seek(to: .zero)
            }
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seekForward() {
        let newTime = player.currentTime().seconds + 10
        player.seek(to: CMTimeMakeWithSeconds(newTime, preferredTimescale: 1))
    }
    
    func seekBackward() {
        let newTime = player.currentTime().seconds - 10
        player.seek(to: CMTimeMakeWithSeconds(newTime, preferredTimescale: 1))
    }
    
    func sliderChanged(editing: Bool) {
        if !editing {
            player.seek(to: CMTimeMakeWithSeconds(currentTime, preferredTimescale: 1))
        }
    }
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

