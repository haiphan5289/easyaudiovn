//
//  ForceUpdateView.swift
//  EasyAudio
//
//  Created by haiphan on 01/02/2023.
//

import UIKit

class ForceUpdateView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
    }
    
    @IBAction func action(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}
