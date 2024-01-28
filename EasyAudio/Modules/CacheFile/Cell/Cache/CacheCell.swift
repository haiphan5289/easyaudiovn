//
//  CacheCell.swift
//  EasyAudio
//
//  Created by haiphan on 27/01/2024.
//

import UIKit


class CacheCell: UITableViewCell {
    
    var removeCacheHandler: (() -> Void)?

    @IBOutlet weak var sizeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sizeLabel.text = "\(ManageApp.shared.getTotalSizeFileManager(urls: ManageApp.shared.getSpaceType(type: .cachesDirectory))) MB"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionSize(_ sender: UIButton) {
        self.removeCacheHandler?()
    }
}
