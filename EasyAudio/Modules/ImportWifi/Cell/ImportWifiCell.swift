//
//  ImportWifiCell.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 25/11/2023.
//

import UIKit

class ImportWifiCell: UICollectionViewCell {

    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stepLabel.text = "Steps"
        self.stepImage.image = UIImage.gifImageWithName("gift_wifi")
    }

}
