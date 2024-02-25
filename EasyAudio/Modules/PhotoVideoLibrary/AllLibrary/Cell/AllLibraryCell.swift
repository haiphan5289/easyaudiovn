//
//  AllLibraryCell.swift
//  EasyAudio
//
//  Created by haiphan on 06/02/2024.
//

import UIKit
import Photos

class AllLibraryCell: UICollectionViewCell {
    
    var tapActionHandler: (() -> Void)?

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func actionSelectButton(_ sender: UIButton) {
        self.tapActionHandler?()
    }
    
    func setValue(model: AllLibraryModel) {
        sizeLabel.text = model.size
        if let time = model.time {
            durationLabel.isHidden = Int(time) ?? 0 <= 0
        }
        
        durationLabel.text = model.time
        BackgroundImage.image = model.image
    }
    
    func getImage(asset: PHAsset?) {
        guard let asset = asset else {
            return
        }
//        BackgroundImage.image = asset.getUIImage()
//        var img: UIImage?
        durationLabel.text = "\(Int(asset.duration).getTextFromSecond())"
        sizeLabel.text = "\(ByteCountFormatter.string(fromByteCount: Int64(asset.getSize()), countStyle: .file))"
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.resizeMode = .exact
        options.isSynchronous = false
        options.version = .original
        options.isNetworkAccessAllowed = true
        
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                self.BackgroundImage.image = UIImage(data: data)
            }
        }
    }
    
    func setSelected(isSelected: Bool) {
        let image = isSelected ? Asset.icCheck.image : Asset.icUncheck.image
        selectButton.setImage(image, for: .normal)
    }

}
