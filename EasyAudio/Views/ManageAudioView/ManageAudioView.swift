//
//  ManageAudioView.swift
//  EasyAudio
//
//  Created by haiphan on 28/08/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol ManageAudioViewDelegate: AnyObject {
    func selectAction(action: MuteFileVC.ActionMusic)
    func setTime(value: Float)
}

class ManageAudioView: UIView {
    
    var delegate: ManageAudioViewDelegate?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lbEndTime: UILabel!
    @IBOutlet var bts: [UIButton]!
    
    @VariableReplay private var statusVideo: MuteFileVC.ActionMusic = .pause
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupRX()
    }
}
extension ManageAudioView {
    
    private func setupUI() {
        self.slider.minimumValue = 0
        self.slider.value = 0
    }
    
    private func setupRX() {
        MuteFileVC.ActionMusic.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.statusVideo = type
            }.disposed(by: self.disposeBag)
        }
        
        self.slider.rx
            .controlEvent([.touchUpInside, .touchUpOutside])
            .withUnretained(self)
            .bind { owner, _ in
                owner.delegate?.setTime(value: owner.slider.value)
            }.disposed(by: disposeBag)
        
        self.$statusVideo.bind { [weak self] stt in
            guard let wSelf = self else { return }
            switch stt {
            case .play:
                wSelf.bts[MuteFileVC.ActionMusic.play.rawValue].isHidden = true
                wSelf.bts[MuteFileVC.ActionMusic.pause.rawValue].isHidden = false
            case .pause:
                wSelf.bts[MuteFileVC.ActionMusic.play.rawValue].isHidden = false
                wSelf.bts[MuteFileVC.ActionMusic.pause.rawValue].isHidden = true
            case .backWard, .forWard: break
            }
            wSelf.delegate?.selectAction(action: stt)
        }.disposed(by: self.disposeBag)
        
    }
    
    func timeProcess(time: Double) {
        self.slider.value = Float(time)
    }
    
    func getDuration(value: Double) {
        self.slider.maximumValue = Float(value)
        self.lbEndTime.text = Int(value).getTextFromSecond()
    }
    
    func updateStatusVideo(stt: MuteFileVC.ActionMusic) {
        self.statusVideo = stt
    }
    
    func updateValueProcess(time: Float) {
        self.slider.value = time
    }
    
}
