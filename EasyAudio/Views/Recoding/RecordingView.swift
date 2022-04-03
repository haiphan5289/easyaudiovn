//
//  RecordingView.swift
//  AudioRecord
//
//  Created by haiphan on 02/11/2021.
//

import UIKit
import RxSwift

protocol RecordingViewDelegate {
    func showRecording()
}

class RecordingView: UIView {
    
    struct Constant {
        static let offSetShadow: CGSize = CGSize(width: 0, height: -18)
        static let opacityShadow: Float = 1
        static let radiusShadow: CGFloat = 54
    }
    
    var delegate: RecordingViewDelegate?
    
    @IBOutlet weak var btRecoding: UIButton!
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
extension RecordingView {
    
    private func setupUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        self.addshadow(top: true, left: true, bottom: true, right: true, color: Asset.shadowBlur3.color, offSet: Constant.offSetShadow, opacity: Constant.opacityShadow, shadowRadius: Constant.radiusShadow)
    }
    
    private func setupRX() {
        self.btRecoding.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            wSelf.delegate?.showRecording()
        }.disposed(by: disposeBag)
    }
    
    
}
