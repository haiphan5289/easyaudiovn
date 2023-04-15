//
//  FadeInOutView.swift
//  EasyAudio
//
//  Created by haiphan on 15/04/2023.
//

import UIKit
import EasyBaseCodes
import RxSwift
import RxRelay

class FadeInOutView: UIView {
    
    var actionHanler: ((_ fadeIn: Double, _ fadeOut: Double) -> Void)?
    
    @IBOutlet weak var audioContentView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var fadeInSlider: UISlider!
    @IBOutlet weak var fadeOutSlider: UISlider!
    @IBOutlet weak var fadeInLabel: UILabel!
    @IBOutlet weak var fadeOutLabel: UILabel!
    private let audioView: AudioView = .loadXib()
    private let headerView: VolumeTitleView = .loadXib()
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    
}
extension FadeInOutView {
    
    private func setupUI() {
        clipsToBounds = true
        layer.setCornerRadius(corner: .verticalTop, radius: 8)
        audioContentView.addSubview(audioView)
        audioView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerContentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.actionHanler = { [weak self] in
            guard let self = self else { return }
            let fadeIn = self.fadeInSlider.value
            let fadeOut = self.fadeOutSlider.value
            self.actionHanler?(Double(fadeIn), Double(fadeOut))
        }
    }
    
    private func setupRX() {
        let fadeInTrigger = self.fadeInSlider.rx.controlEvent(.valueChanged).mapToVoid().startWith(())
        let fadeOutTrigger = self.fadeOutSlider.rx.controlEvent(.valueChanged).mapToVoid()
        
        Observable.merge(fadeInTrigger, fadeOutTrigger)
            .withUnretained(self)
            .bind { owner, item in
                let fadeIn = owner.fadeInSlider.value
                let fadeOut = owner.fadeOutSlider.value
                owner.fadeInLabel.text = "\(Int(fadeIn))s"
                owner.fadeOutLabel.text = "\(Int(fadeOut))s"
                owner.audioView.fadeIn(volume: fadeIn)
                owner.audioView.fadeOut(volume: fadeOut)
                owner.audioView.audioType = .fade
            }.disposed(by: disposeBag)
    }
    
    func setTitle(title: String?) {
        headerView.setTitle(title: title)
    }

    func setupAudioURL(url: URL) {
        audioView.setupURL(url: url)
    }
}


