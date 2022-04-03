//
//  NavigationItemView.swift
//  Note
//
//  Created by haiphan on 02/10/2021.
//

import UIKit
import RxSwift

class NavigationItemView: UIView {
    
    var actionItem: ((ActionNavigation) -> Void)?
    
    enum ActionNavigation: Int, CaseIterable {
        case close, reminder, pin, export, done
    }
    
    @IBOutlet var bts: [UIButton]!
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
extension NavigationItemView {
    
    private func setupUI() {
        ActionNavigation.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            let bt = wSelf.bts[type.rawValue]
            
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.actionItem?(type)
            }.disposed(by: disposeBag)
        }
        
    }
    
    private func setupRX() {
        
    }
}
 
