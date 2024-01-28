//
//  PhotoSizeLargeView.swift
//  EasyAudio
//
//  Created by haiphan on 27/01/2024.
//

import UIKit

class PhotoSizeLargeView: UIView {
    
    var viewAllHandler: (() -> Void)?
    
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var thumnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionViewAll(_ sender: UIButton) {
        self.viewAllHandler?()
    }
    
    func showDuration(duration: Int64) {
        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: duration, countStyle: .file)
        durationLabel.text = fileSizeWithUnit
    }
    
    func showImage(image: UIImage?) {
        thumnailImage.image = image
    }
    
    func setCount(count: Int) {
        durationView.isHidden = true
        countView.isHidden = false
        countLabel.text = "+\(count)"
        
    }
    
}
