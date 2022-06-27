//
//  VideoCell.swift
//  EasyAudio
//
//  Created by haiphan on 26/06/2022.
//

import UIKit

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbDuration: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }

}
extension VideoCell {
    
    func setupVideo(videoURL: URL) {
        self.img.image = videoURL.getThumbnailImage()
        self.lbDuration.text = "\(videoURL.getDuration())"
    }
    
}
