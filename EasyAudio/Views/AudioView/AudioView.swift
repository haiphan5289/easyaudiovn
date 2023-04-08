//
//  AudioView.swift
//  EasyAudio
//
//  Created by haiphan on 25/03/2023.
//

import UIKit
import RxCocoa
import RxSwift


class AudioView: UIView {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var processTimeSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    
    private let urlTrigger: PublishSubject<URL> = PublishSubject.init()
    private let audioPLayManage: AudioPlayManage = AudioPlayManage()
    private var valueVolume: Float = 10
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AudioView {
    
    private func setupUI() {
        audioPLayManage.delegate = self
    }
    
    private func setupRX() {
        urlTrigger
            .withUnretained(self)
            .bind { owner, url in
                owner.durationLabel.text = "00:00/\(Int(url.getDuration()).getTextFromSecond())"
                owner.processTimeSlider.value = 0
                owner.processTimeSlider.minimumValue = 0
                owner.processTimeSlider.maximumValue = Float(url.getDuration())
                owner.audioPLayManage.playAudio(url: url, currentTime: 0)
                owner.audioPLayManage.setVolume(volume: owner.valueVolume)
            }.disposed(by: disposeBag)
        
        playButton.rx.tap
            .withLatestFrom(urlTrigger)
            .withUnretained(self)
            .bind { owner, url in
                
                if owner.audioPLayManage.isplay() {
                    owner.audioPLayManage.pauseAudio()
                    owner.audioPLayManage.clearAction()
                    owner.playButton.setImage(Asset.icPlay.image, for: .normal)
                    return
                }
                
                owner.playButton.setImage(Asset.icPause.image, for: .normal)
                owner.audioPLayManage.playAudio(url: url, currentTime: CGFloat(owner.processTimeSlider.value))
                owner.audioPLayManage.setVolume(volume: owner.valueVolume)
            }.disposed(by: disposeBag)
    }
    
    func setupURL(url: URL) {
        urlTrigger.onNext(url)
    }
    
    func setVolume(volume: Float) {
        self.valueVolume = volume
    }
    
}
extension AudioView: AudioPlayManageDelegate {
    func valueProcessing(value: CGFloat) {
        self.processTimeSlider.value = Float(value)
        let endTime = Int(self.processTimeSlider.maximumValue).getTextFromSecond()
        self.durationLabel.text = "\(Int(value).getTextFromSecond())/\(endTime)"
    }
    
    func didFinishAudio() {
        playButton.setImage(Asset.icPlay.image, for: .normal)
    }
}
