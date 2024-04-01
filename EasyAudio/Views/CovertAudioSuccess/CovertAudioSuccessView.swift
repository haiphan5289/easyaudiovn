//
//  CovertAudioSuccessView.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 01/04/2024.
//

import UIKit

class CovertAudioSuccessView: UIView {
    
    var moveActionHandler: (() -> Void)?
    
    @IBAction func stayHereAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func moveAction(_ sender: UIButton) {
        self.moveActionHandler?()
    }
    
    
    @IBOutlet weak var stayHereButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
