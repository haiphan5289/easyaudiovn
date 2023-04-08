//
//  AudioManage.swift
//  EasyAudio
//
//  Created by haiphan on 08/04/2023.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

protocol AudioPlayManageDelegate: AnyObject {
    
    func valueProcessing(value: CGFloat)
    func didFinishAudio()
}

final class AudioPlayManage: NSObject {
    
    weak var delegate: AudioPlayManageDelegate?
    
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var detectTime: Disposable?
    
    override init() { }
    
    func playAudio(url: URL, currentTime: CGFloat) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.currentTime = TimeInterval(currentTime)
            self.autoRunTime()
        } catch {
        }
    }
    
    func pauseAudio() {
        self.audioPlayer.pause()
    }
    
    func isplay() -> Bool {
        return self.audioPlayer.isPlaying
    }
    
    func clearAction() {
        detectTime?.dispose()
    }
    func autoRunTime() {
        detectTime?.dispose()
        
        detectTime = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] (time) in
                guard let wSelf = self else { return }
                print("======== \(wSelf.audioPlayer.currentTime)")
                wSelf.delegate?.valueProcessing(value: wSelf.audioPlayer.currentTime)
            })
    }
}
extension AudioPlayManage: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.clearAction()
        self.delegate?.didFinishAudio()
    }
}
