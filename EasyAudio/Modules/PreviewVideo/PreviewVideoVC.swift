//
//  PreviewVideoVC.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 03/04/2024.
//

import UIKit
import RxSwift
import RxCocoa
import EasyBaseAudio
import MobileCoreServices
import SVProgressHUD
import VisionKit
import SnapKit
import AVFoundation

class PreviewVideoVC: UIViewController {
    
    var inputURL: URL?

    @VariableReplay private var audioRange: RangeTimeSlider = RangeTimeSlider.empty
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    
    @IBOutlet weak var videoFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
extension PreviewVideoVC {
    
    private func setupUI() {
        if let inputURL = self.inputURL {
            self.playURL(url: inputURL)
        }
    }
    
    private func setupRX() {
        
    }
    
    private func playURL(url: URL) {
        self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.videoFrame)
        self.avplayerManager.doAVPlayer(action: .play)
    }
    
}
