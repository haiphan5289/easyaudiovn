//
//  AVPlayerManager.swift
//  EasyAudio
//
//  Created by haiphan on 09/06/2022.
//

import Foundation
import AVFoundation
import UIKit
import RxSwift

protocol AVPlayerManagerDelegate: AnyObject {
    func didFinishAVPlayer()
    func timeProcess(time: Double)
    func getDuration(value: Double)
}

final class AVPlayerManager {
    
    enum Action {
        case play, pause, mute, rewind(Float64), forward(Float64)
    }
    
    var videoURL: URL?
    var player: AVPlayer?
    weak var delegate: AVPlayerManagerDelegate?
    private var autoRunAudio: Disposable?
    public init() {
        self.setup()
    }
    
    deinit {
        self.disAudoRun()
        self.doAVPlayer(action: .pause)
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerEndedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
       DispatchQueue.main.async {[weak self] in
           guard let wSelf = self else { return }
           wSelf.player?.seek(to: .zero)
           wSelf.doAVPlayer(action: .pause)
           wSelf.delegate?.didFinishAVPlayer()
           wSelf.disAudoRun()
       }
    }
    
    func doAVPlayer(action: Action) {
        guard let player = self.player else {
            return
        }
        switch action {
        case .play: player.play()
        case .pause: player.pause()
        case .mute: player.isMuted = true
        case .forward(let value): self.forwardVideo(by: value)
        case .rewind(let value): self.rewindVideo(by: value)
        }
    }
    
    
    func playToTime(value: Float) {
        player?.seek(to: CMTime(value: CMTimeValue(value * 1000), timescale: 1000))
    }
    
    func rewindVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }

    func forwardVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    func getDuration() -> Double {
        guard let videoURL = videoURL else {
            return 0
        }
        return videoURL.getDuration()
    }
    
    func loadVideoURL(videoURL: URL, videoView: UIView) {
        self.videoURL = videoURL
        let asset = AVAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        
        //3. Create AVPlayerLayer object
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = videoView.bounds //bounds of the view in which AVPlayer should be displayed
        playerLayer.videoGravity = .resizeAspect
        
        //4. Add playerLayer to view's layer
        videoView.layer.addSublayer(playerLayer)
        self.delegate?.getDuration(value: videoURL.getDuration())
        
        guard let player = player else {
            return
        }
        self.autoRun()
        
//        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2),
//                                       queue: DispatchQueue.main) {[weak self] (progressTime) in
//            guard let wSelf = self else { return }
//            wSelf.delegate?.timeProcess(time: CMTimeGetSeconds(progressTime))
////            if let duration = player.currentItem?.duration {
////                let durationSeconds = CMTimeGetSeconds(duration)
////                wSelf.progress = CMTimeGetSeconds(progressTime)
////                percent = Float(seconds/durationSeconds)
////                print("====== \(wSelf.progress)")
////                DispatchQueue.main.async {
////                    if (wSelf.progress ?? 0) >= 1.0 {
////                        wSelf.progress = 0.0
////                    }
////                }
////            }
//        }
    }
    
    private func disAudoRun() {
        self.autoRunAudio?.dispose()
    }
    
    private func autoRun() {
        self.autoRunAudio?.dispose()
        self.autoRunAudio = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance).bind(onNext: { [weak self] time in
            guard let wSelf = self, let player = wSelf.player else { return }
            wSelf.delegate?.timeProcess(time: player.currentItem?.currentTime().seconds ?? 0)
        })
    }
}
