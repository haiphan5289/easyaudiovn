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
    
    func setVolume(volume: Float) {
        self.audioPlayer.volume = volume
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
    
    func fadeOut(vol: Float) {
        self.audioPlayer.fadeOut(vol: vol)
    }
    
    func fadeIn(vol: Float) {
        self.audioPlayer.fadeIn(vol: vol)
    }
    
}
extension AudioPlayManage: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.clearAction()
        self.delegate?.didFinishAudio()
    }
}

extension AVAudioPlayer {
    
    private func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    func fadeOut(vol: Float) {
        if volume > vol {
            //print("vol is : \(vol) and volume is: \(volume)")
            dispatchDelay(delay: 0.1, closure: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.volume -= 0.01
                strongSelf.fadeOut(vol: vol)
            })
        } else {
            volume = vol
        }
    }
    func fadeIn(vol:Float) {
        if volume < vol {
            dispatchDelay(delay: 0.1, closure: {
                [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.volume += 0.01
                strongSelf.fadeIn(vol: vol)
            })
        } else {
            volume = vol
        }
    }
}
