//
//  SpeedView.swift
//  EasyAudio
//
//  Created by haiphan on 16/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SpeedView: UIView {
    
    var actionHanler: ((_ speed: Double) -> Void)?
    
    @IBOutlet weak var audioContentView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var speedSlider: UISlider!
    private let audioView: AudioView = .loadXib()
    private let headerView: VolumeTitleView = .loadXib()
    private let valueLabel: UILabel = UILabel(frame: .zero)
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
}
extension SpeedView {
    
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
            self.actionHanler?(Double(self.speedSlider.value))
        }
        
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.mySystemFont(ofSize: 11)
        valueLabel.textColor = .white
        self.addSubview(valueLabel)
    }
    
    private func setupRX() {
        speedSlider.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { owner, _ in
                owner.audioView.setVolume(volume: owner.speedSlider.value)
                
                owner.speedSlider.subviews.forEach { view in
                    view.subviews.forEach { view in
                        if let image = view as? UIImageView {
                            let frame = owner.convert(image.frame, to: nil)
                            owner.handleValueLabel(frame: frame)
                        }
                    }
                }
                owner.audioView.setSpeed(speed: Double(owner.speedSlider.value))
                owner.audioView.audioType = .speed
            }.disposed(by: disposeBag)
    }
    
    func handleValueLabel(frame: CGRect) {
        var f = frame
        UIView.animate(withDuration: 0.5) {
            f.origin.y -= 30
            self.valueLabel.text = "\(Int(self.speedSlider.value))x"
            let frameY = self.convert(self.speedSlider.frame, to: nil)
            self.valueLabel.frame = CGRect(x: f.origin.x, y: frameY.origin.y - 400, width: 50, height: 50)
        }
    }
    
    func setTitle(title: String?) {
        headerView.setTitle(title: title)
    }
    
    func setupAudioURL(url: URL) {
        audioView.setupURL(url: url)
    }
    
}
