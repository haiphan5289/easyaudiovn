//
//  VolumeView.swift
//  EasyAudio
//
//  Created by haiphan on 25/03/2023.
//

import UIKit
import EasyBaseCodes

class VolumeView: UIView {
    
    var actionHanler: ((Float) -> Void)?
    
    @IBOutlet weak var audioContentView: UIView!
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    private let audioView: AudioView = .loadXib()
    private let headerView: VolumeTitleView = .loadXib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}
extension VolumeView {
    
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
            self.actionHanler?(self.volumeSlider.value)
        }
    }
    
    func setTitle(title: String?) {
        headerView.setTitle(title: title)
    }
    
    func setupAudioURL(url: URL) {
        audioView.setupURL(url: url)
    }
    
}
