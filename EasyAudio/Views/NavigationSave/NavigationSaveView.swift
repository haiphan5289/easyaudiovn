//
//  NavigationSaveView.swift
//  ManageFiles
//
//  Created by haiphan on 20/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol NavigationSaveViewDelegate {
    func action(action: NavigationSaveView.Action)
}

class NavigationSaveView: UIView {
    
    enum Action: Int, CaseIterable {
        case back, save
    }
    
    var delegate: NavigationSaveViewDelegate?
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var bts: [UIButton]!
    
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
extension NavigationSaveView {
    
    private func setupRX() {
        Action.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            let bt = wSelf.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.delegate?.action(action: type)
            }.disposed(by: wSelf.disposeBag)
        }
    }
    
    func setupLabel(text: String) {
        self.lbTitle.text = text
    }
    
    func setupTextButton(text: String) {
        self.bts[Action.save.rawValue].setTitle(text, for: .normal)
    }
    
}
