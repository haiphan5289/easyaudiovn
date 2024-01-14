//
//  MainActionCell.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 19/11/2023.
//

import UIKit

class MainActionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindType(type: MainActionVC.MainActionType) {
        titleLabel.text = type.title
        icon.image = type.image
        descriptionLabel.text = type.description
    }
    
}
