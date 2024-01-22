//
//  AudioCell.swift
//  EasyAudio
//
//  Created by haiphan on 04/04/2022.
//

import UIKit

class AudioCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imageThumail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.layer.cornerRadius = 14
        self.mainView.clipsToBounds = true
        self.mainView.dropShadow(color: Asset.blackOpacity60.color, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension AudioCell {
    
    func setupValue(url: URL, filterType: FilterVC.FilterType) {
        self.lbName.text = url.getName()
        var dateStr: String = url.creation?.covertToString(format: .MMddyyyy) ?? ""
        switch filterType {
        case .accessDateAscending, .accessedDateDescending:
            dateStr = url.contentAccess?.covertToString(format: .MMddyyyy) ?? ""
        case .modifiDateDescending, .modifiDateAscending:
            dateStr = url.contentModification?.covertToString(format: .MMddyyyy) ?? ""
        case .createDateAscending, .createDateDescending:
            dateStr = url.creation?.covertToString(format: .MMddyyyy) ?? ""
        case .nameAscending, .nameDescending: break
        }
        self.lbTime.text = "\(url.getTime()) ● \(url.getSize() ?? 0) MB ● \(dateStr)"
        let image = (url.getThumbnailImage() != nil) ? url.getThumbnailImage() : Asset.icPlacdeHolder.image
        self.imageThumail.image = image
    }
    
    func setWork(url: URL) {
        self.lbName.text = url.getName()
        self.lbTime.text = "\(url.getSize() ?? 0) MB ● \(url.creation?.covertToString(format: .MMddyyyy) ?? "")"
        let image = (url.getThumbnailImage() != nil) ? url.getThumbnailImage() : Asset.icPlacdeHolder.image
        self.imageThumail.image = image
    }
    
}
