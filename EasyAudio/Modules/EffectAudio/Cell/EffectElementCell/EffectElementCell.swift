//
//  EffectElementCell.swift
//  EasyAudio
//
//  Created by haiphan on 02/05/2023.
//

import UIKit

class EffectElementCell: UITableViewCell {

    private let effectElement: EffectElementView = .loadXib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(effectElement)
        effectElement.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
