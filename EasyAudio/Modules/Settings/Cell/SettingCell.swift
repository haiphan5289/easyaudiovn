//
//  SettingCell.swift
//  EasyAudio
//
//  Created by haiphan on 01/09/2022.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SettingCell {
    
    func setValue(type: SettingVC.StatusSetting) {
        self.img.image = type.img
        self.lbTitle.text = type.text
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let text = self.lbTitle.text,
           type == .version {
            self.lbTitle.text = text + " \(version)"
        }
    }
    
}
