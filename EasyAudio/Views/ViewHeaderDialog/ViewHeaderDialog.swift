//
//  ViewHeaderDialog.swift
//  Note
//
//  Created by haiphan on 07/10/2021.
//

import UIKit
import RxSwift

class ViewHeaderDialog: UIView {
    
    enum ActionHeader: Int, CaseIterable {
        case cancel, done
    }
    
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var lbTitleHeader: UILabel!
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
extension ViewHeaderDialog {
    
    private func setupUI() {
    }
    
    private func setupRX() {

    }
    
    func updateTitleHeader(text: String) {
        self.lbTitleHeader.text = text
    }
    
}

