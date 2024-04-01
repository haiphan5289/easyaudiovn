//
//  VideoCell.swift
//  EasyAudio
//
//  Created by haiphan on 26/06/2022.
//

import UIKit
import AVFoundation

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
        if let img = self.thumbnailFromVideo(videoUrl: videoURL,
                                             time: CMTimeMake(value: Int64(videoURL.getDuration()), timescale: 1)) {
            self.img.image = img
        }
        self.lbDuration.text = "\(Int(videoURL.getDuration()).getTextFromSecond())"
    }
    
     func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage? {
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        }catch{
            
        }
         return UIImage(named: "ic_viideo")
    }
    
}

