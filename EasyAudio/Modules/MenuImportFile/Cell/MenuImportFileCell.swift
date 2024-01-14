//
//  MenuImportFileCell.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 14/01/2024.
//

import UIKit

class MenuImportFileCell: UICollectionViewCell {

    @IBOutlet weak var iconMenu: UIImageView!
    @IBOutlet weak var titleMenu: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMenu(menu: AdditionAudioVC.Action) {
        iconMenu.image = menu.image
        titleMenu.text = menu.title
    }

}
