//
//  TimeView.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//

import UIKit

class TimeView: UIView {
    
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
}
extension TimeView {
    
    func loadTime(time: Int) {
        self.lbTime.text = time.getTextFromSecond()
    }
    
}
