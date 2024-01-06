//
//  FeatureCell.swift
//  EasyAudio
//
//  Created by haiphan on 06/01/2024.
//

import UIKit

class FeatureCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindValue(type: FeaturesView.FeatureType) {
        icon.image = type.image
        titleLabel.text = type.title
    }

}
