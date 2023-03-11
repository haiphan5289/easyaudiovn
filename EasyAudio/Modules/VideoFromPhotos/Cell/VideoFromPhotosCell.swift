//
//  VideoFromPhotosCell.swift
//  EasyAudio
//
//  Created by haiphan on 11/03/2023.
//

import UIKit
import Photos
import EasyBaseCodes

class VideoFromPhotosCell: UICollectionViewCell {

    @IBOutlet weak var imgAsset: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 4
    }

}
extension VideoFromPhotosCell {
    
    func bindModel(model: PHAsset) {
        imgAsset.image = model.getUIImage()
        backgroundColor = model.getUIImage() == nil ? .black : .clear
        durationLabel.text = Int(model.duration).getTextFromSecond()
    }
    
}
