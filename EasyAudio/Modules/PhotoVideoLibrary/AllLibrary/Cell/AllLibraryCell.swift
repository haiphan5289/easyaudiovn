//
//  AllLibraryCell.swift
//  EasyAudio
//
//  Created by haiphan on 06/02/2024.
//

import UIKit

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
    
    func setSelected(isSelected: Bool) {
        let image = isSelected ? Asset.icCheck.image : Asset.icUncheck.image
        selectButton.setImage(image, for: .normal)
    }

}
