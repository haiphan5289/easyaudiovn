//
//  GeneralInfoCell.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 21/01/2024.
//

import UIKit

class GeneralInfoCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var widthUsedView: NSLayoutConstraint!
    @IBOutlet weak var widthFreeSizeView: NSLayoutConstraint!
    @IBOutlet weak var appSizeLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension GeneralInfoCell {
    
    private func setupUI() {
        DispatchQueue.main.async {
            let totalWidth = self.stackView.frame.width
            var widthApp = (ManageApp.shared.ratioAppSizewithSystem() ?? 0) * totalWidth
            
            if widthApp <= 30 {
                widthApp = 30
            }
            self.widthUsedView.constant = widthApp
            let freeSize = Double(ManageApp.shared.getSizeDeviceType(type: .systemFreeSize) ?? 0) / Double(ManageApp.shared.getSizeDeviceType(type: .systemSize) ?? 1)
            
            self.widthFreeSizeView.constant = CGFloat(freeSize) * totalWidth
            self.appSizeLabel.text = "\(ManageApp.shared.appSizeInMegaBytes()) MB"
            self.makeDescriptionLabel()
        }
        //        let appSize = self.appSizeInMegaBytes()
        //        print("appSize --- \(appSize)")
        //        print("FreeSpace --- \(self.getFreeSpace().toMB())")
        //        print("getUsedSpace --- \(self.getUsedSpace().toMB())")
        //        print("getTotalSpace --- \(self.getTotalSpace().toMB())")
        //        print("Size Device --- \(physicalMemory) ")
        //        print("deviceRemainingFreeSpace --- \(self.deviceRemainingFreeSpace() ?? 0)")
    }
    
    private func makeDescriptionLabel() {
        let ratio = "\(ManageApp.shared.ratioAppSizewithSystem()?.rounded(.up) ?? 0)%"
        let att = NSMutableAttributedString(string: "Chiếm \(ratio) dung lượng điện thoại", attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                                                    .foregroundColor: UIColor.gray])
        let range = att.mutableString.range(of: ratio, options:NSString.CompareOptions.caseInsensitive)
        att.addAttribute(.font,
                         value: UIFont.boldSystemFont(ofSize: 13),
                         range: range)
        desLabel.attributedText = att
    }
    
}
