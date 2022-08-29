
//
//  
//  PlayMusicVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/08/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import AVFoundation

class PlayMusicVC: UIViewController, BaseAudioProtocol {
    
    // Add here outlets
    @IBOutlet weak var heighTopView: NSLayoutConstraint!
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var contentAudioView: UIView!
    @IBOutlet weak var btBack: UIButton!
    private let manageView: ManageAudioView = .loadXib()
    var url: URL?
    
    // Add here your view model
    private var viewModel: PlayMusicVM = PlayMusicVM()
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.avplayerManager.doAVPlayer(action: .pause)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension PlayMusicVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.heightBottomView.constant = GetHeightSafeArea.shared.getHeight(type: .bottom)
        self.heighTopView.constant = GetHeightSafeArea.shared.getHeight(type: .top) + 50
        self.avplayerManager.delegate = self
        self.contentAudioView.addSubview(self.manageView)
        self.manageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.manageView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = self.url {
                self.playURL(url: url)
            }
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.btBack.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController()
            }.disposed(by: disposeBag)
    }
    
    private func playURL(url: URL) {
        self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.view)
        self.avplayerManager.doAVPlayer(action: .play)
        self.manageView.updateStatusVideo(stt: .play)
    }
    
    private func updateValueProcess(time: Float) {
        self.manageView.updateValueProcess(time: time)
    }
    
}
extension PlayMusicVC: ManageAudioViewDelegate {
    
    func setTime(value: Float) {
        self.avplayerManager.doAVPlayer(action: .pause)
        self.avplayerManager.playToTime(value: value)
        self.avplayerManager.doAVPlayer(action: .play)
    }
    
    func selectAction(action: MuteFileVC.ActionMusic) {
        switch action {
        case .play:
            self.avplayerManager.doAVPlayer(action: .play)
        case .pause:
            self.avplayerManager.doAVPlayer(action: .pause)
        case .backWard:
            self.avplayerManager.doAVPlayer(action: .rewind(5))
        case .forWard:
            self.avplayerManager.doAVPlayer(action: .forward(5))
        }
    }
}
extension PlayMusicVC: AVPlayerManagerDelegate {
    func getDuration(value: Double) {
        self.manageView.getDuration(value: value)
    }
    
    func didFinishAVPlayer() {
        self.manageView.updateStatusVideo(stt: .pause)
    }
    
    func timeProcess(time: Double) {
        self.manageView.timeProcess(time: time)
    }
}
