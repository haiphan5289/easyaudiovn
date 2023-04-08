//
//  VolumeTitleView.swift
//  EasyAudio
//
//  Created by haiphan on 25/03/2023.
//

import UIKit

class VolumeTitleView: UIView {
    
    var actionHanler: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        self.actionHanler?()
    }
    func setTitle(title: String?) {
        nameLabel.text = title
    }
    
}
