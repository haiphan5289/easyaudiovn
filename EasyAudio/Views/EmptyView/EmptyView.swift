//
//  EmptyView.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    let imgView: UIImageView = UIImageView(frame: .zero)
    let lbText: UILabel = UILabel(frame: .zero)
    
    init(frame: CGRect, image: UIImage = Asset.icEmptyView.image, text: String = "You don't have data") {
        self.imgView.image = image
        self.lbText.text = text
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension EmptyView {
    
    private func setupView() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [],
                                                 axis: .vertical,
                                                 spacing: 8,
                                                 alignment: .center,
                                                 distribution: .fill)
        self.lbText.font = UIFont.myMediumSystemFont(ofSize: 18)
        self.lbText.textAlignment = .center
        self.lbText.numberOfLines = 0
        
        stackView.addArrangedSubview(self.imgView)
        stackView.addArrangedSubview(self.lbText)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
    }
    
}
