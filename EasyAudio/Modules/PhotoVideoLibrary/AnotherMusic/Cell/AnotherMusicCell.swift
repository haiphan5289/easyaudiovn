//
//  AnotherMusicCell.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 23/02/2024.
//

import UIKit

class AnotherMusicCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var iconSelected: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let image = selected ? Asset.icCheck.image : Asset.icUncheck.image
        iconSelected.image = image
        // Configure the view for the selected state
    }
    
    func setModel(model: AnotherMediaModel) {
        self.title.text = model.title
        self.sizeLabel.text = model.size
    }
    
}
