//
//  QuickActionsView.swift
//  AudioRecord
//
//  Created by haiphan on 07/11/2021.
//

import UIKit
import RxSwift

protocol QuickActionDelegate {
    func action(action: QuickActionsView.QuickActionType, audioURL: URL)
}

class QuickActionsView: UIView {
    
    enum LabelType: Int, CaseIterable {
        case title, type, date, size, duration
    }
    
    enum WidthContraint: Int, CaseIterable {
        case type, date, size
    }
    
    enum QuickActionType: Int, CaseIterable {
        case share, edit, star, duplicate, rename, save, trash
    }
    
    var delegate: QuickActionDelegate?
    var audioURL: URL?
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var lbs: [UILabel]!
    @IBOutlet var widths: [NSLayoutConstraint]!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    private var effect: UIVisualEffect?
    private let tap: UITapGestureRecognizer = UITapGestureRecognizer()
    
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
extension QuickActionsView {
    
    private func setupUI() {
        self.visualEffectView.alpha = 0.9
        //        self.addSubview(self.homeRecodingView)
        //        self.homeRecodingView.backgroundColor = .white
        //        self.homeRecodingView.clipsToBounds = true
        //        self.homeRecodingView.layer.cornerRadius = ConstantApp.shared.radiusHomeRecodings
        //        self.homeRecodingView.addShadow(ofColor: Asset.f4F4F4.color, radius: Constant.radiusShadow, offset: Constant.offSetShadow, opacity: Constant.opacityShadow)
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
        
        self.visualEffectView.addGestureRecognizer(self.tap)
        
    }
    
    private func setupRX() {
        self.tap.rx.event.asObservable().bind { [weak self] _ in
            guard let wSelf = self else { return }
            wSelf.animateout()
        }.disposed(by: disposeBag)
        
        QuickActionType.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            let bt = wSelf.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self, let url = wSelf.audioURL else { return }
                wSelf.delegate?.action(action: type, audioURL: url)
            }.disposed(by: disposeBag)
        }
    }
    
    func updateValue(rect: CGRect) {
        //        self.homeRecodingView.frame = rect
        self.animatein()
        self.calculateWidth()
    }
    
    private func calculateWidth() {
        self.widths[WidthContraint.type.rawValue].constant = self.lbs[LabelType.type.rawValue].sizeThatFits(self.lbs[LabelType.type.rawValue].bounds.size).width
        self.widths[WidthContraint.date.rawValue].constant = self.lbs[LabelType.date.rawValue].sizeThatFits(self.lbs[LabelType.date.rawValue].bounds.size).width
        self.widths[WidthContraint.size.rawValue].constant = self.lbs[LabelType.size.rawValue].sizeThatFits(self.lbs[LabelType.size.rawValue].bounds.size).width
    }
    
    private func animateout() {
        self.stackView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = nil
            self.stackView.transform = CGAffineTransform.identity
            self.hideView()
        }
    }
    
    private func animatein() {
        self.stackView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = self.effect
            self.stackView.transform = CGAffineTransform.identity
        }
    }
    
    func showView() {
        self.isHidden = false
    }
    
    func hideView() {
        self.isHidden = true
    }
}
