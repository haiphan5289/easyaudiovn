
//
//  
//  MuteFileVC.swift
//  EasyAudio
//
//  Created by haiphan on 02/06/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio
import MobileCoreServices
import SVProgressHUD
import VisionKit
import SnapKit
import AVFoundation

class MuteFileVC: BaseVC {
    
    enum ActionMusic: Int, CaseIterable {
        case backWard, play, pause, forWard
    }
    
    enum Export: Int, CaseIterable {
        case preview, export
    }
    
    @IBOutlet var btExpots: [UIButton]!
    // Add here outlets
    @IBOutlet weak var videoAB: ABVideoRangeSlider!
    @IBOutlet weak var btImport: UIButton!
    @IBOutlet weak var videoFrame: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lbEndTime: UILabel!
    @IBOutlet var bts: [UIButton]!
    
    // Add here your view model
    private var viewModel: MuteFileVM = MuteFileVM()
    @VariableReplay private var statusVideo: ActionMusic = .pause
    @VariableReplay private var audioRange: RangeTimeSlider = RangeTimeSlider.empty
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
        self.setupNavi(bgColor: Asset.appColor.color, textColor: .black, font: UIFont.mySystemFont(ofSize: 18))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    deinit {
        print("====== ")
    }
    
}
extension MuteFileVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Mute File"
        self.videoAB.delegate = self
        self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
        self.avplayerManager.delegate = self
        self.slider.minimumValue = 0
        self.slider.value = 0
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        ActionMusic.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.statusVideo = type
            }.disposed(by: self.disposeBag)
        }
        
        Export.allCases.forEach { type in
            let bt = self.btExpots[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let self = self else { return }
                switch type {
                case .preview:
                    print()
                case .export:
                    AudioManage.shared.covertToAudio(url: self.videoAB.videoURL,
                                                     folder: ConstantApp.FolderName.folderVideo.rawValue,
                                                     type: .mp4) { [weak self] outputURL in
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController()
                        }
                    } failure: { msg in
                        self.showAlert(title: nil, message: msg)
                    }

                }
            }.disposed(by: disposeBag)
        }
        
        self.$statusVideo.bind { [weak self] stt in
            guard let wSelf = self else { return }
            switch stt {
            case .play:
                wSelf.bts[ActionMusic.play.rawValue].isHidden = true
                wSelf.bts[ActionMusic.pause.rawValue].isHidden = false
                wSelf.avplayerManager.doAVPlayer(action: .play)
            case .pause:
                wSelf.bts[ActionMusic.play.rawValue].isHidden = false
                wSelf.bts[ActionMusic.pause.rawValue].isHidden = true
                wSelf.avplayerManager.doAVPlayer(action: .pause)
            case .backWard:
                wSelf.avplayerManager.doAVPlayer(action: .rewind(5))
            case .forWard:
                wSelf.avplayerManager.doAVPlayer(action: .forward(5))
            }
        }.disposed(by: self.disposeBag)
        self.btImport.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            let vc = AdditionAudioVC.createVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.status = .mute
            wSelf.present(vc, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        self.buttonLeft.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController(animated: true, nil)
        }.disposed(by: self.disposeBag)
        
        self.$audioRange
            .asObservable()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] range in
                guard let self = self, range.end - range.start >= 2 else {
                    self?.showAlert(title: nil, message: "Audio phải dài hơn 2s")
                    return
                }
                AudioManage.shared.cropVideo(sourceURL: self.videoAB.videoURL,
                                             rangeTimeSlider: range,
                                             folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.playURL(url: outputURL)
                    }
                } failure: { [weak self] err in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.showAlert(title: nil, message: err.localizedDescription)
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func updateURLVideo(url: URL) {
        self.videoAB.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
        self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
        self.videoAB.waveForm.isHidden = true
        self.videoAB.updateThumbnails()
        self.playURL(url: url)
    }
    
    private func playURL(url: URL) {
        self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.videoFrame)
        self.avplayerManager.doAVPlayer(action: .play)
        self.statusVideo = .play
    }
    
    private func updateValueProcess(time: Float) {
        self.slider.value = time
    }
}
extension MuteFileVC: AdditionAudioDelegate {
    func action(action: AdditionAudioVC.Action) {
        switch action {
        case .photoLibrary:
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = ["public.movie"]
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        case .iCloud:
            let types = [kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG2Video]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            //                        documentPicker.shouldShowFileExtensions = true
            self.present(documentPicker, animated: true, completion: nil)
        case .recording, .audio: break
        case .wifi:
            let vc = ImportWifiVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension MuteFileVC: ImportWifiDelegate {
    func addURL(url: URL) {
        AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: url, folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.updateURLVideo(url: outputURL)
            }
        }
    }
}
extension MuteFileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL, folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                        wSelf.updateURLVideo(url: outputURL)
                    }
                }
            }
        }
    }
    
}
extension MuteFileVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        SVProgressHUD.show()
        //If There isn't convert Mpr, you can ỉncrease time Dispatch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AudioManage.shared.encodeVideo(folderName: ConstantApp.FolderName.folderEdit.rawValue, videoURL: first) { outputURL in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    DispatchQueue.main.async {
                        self.updateURLVideo(url: outputURL)
                        SVProgressHUD.dismiss()
                    }
                }
                
//                AudioManage.shared.covertToCAF(folderConvert: ConstantApp.FolderName.folderEdit.rawValue, url: outputURL, type: .caf) { [weak self] outputURLBrowser in
//                    guard let wSelf = self else { return }
//                    DispatchQueue.main.async {
//                        wSelf.updateURLVideo(url: outputURLBrowser)
//                        SVProgressHUD.dismiss()
//                    }
//
//                } failure: { [weak self] text in
//                    SVProgressHUD.dismiss()
//                    guard let wSelf = self else { return }
//                    wSelf.showAlert(title: nil, message: text)
//                }
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            AudioManage.shared.covertToAudio(url: first, folder: ConstantApp.FolderName.folderEdit.rawValue, type: .mp4) { outputURL in
//                AudioManage.shared.covertToCAF(folderConvert: ConstantApp.FolderName.folderEdit.rawValue, url: outputURL, type: .caf) { [weak self] outputURLBrowser in
//                    guard let wSelf = self else { return }
//                    DispatchQueue.main.async {
//                        wSelf.updateURLVideo(url: outputURLBrowser)
//                        SVProgressHUD.dismiss()
//                    }
//
//                } failure: { [weak self] text in
//                    SVProgressHUD.dismiss()
//                    guard let wSelf = self else { return }
//                    wSelf.showAlert(title: nil, message: text)
//                }
//            } failure: { _ in
//
//            }
//
//
//        }

    }
}
extension MuteFileVC: AVPlayerManagerDelegate {
    func getDuration(value: Double) {
        self.slider.maximumValue = Float(value)
        self.lbEndTime.text = Int(value).getTextFromSecond()
    }
    
    func didFinishAVPlayer() {
        self.statusVideo = .pause
    }
    
    func timeProcess(time: Double) {
        self.updateValueProcess(time: Float(time))
    }
}
extension MuteFileVC: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.audioRange = RangeTimeSlider(start: startTime, end: endTime)
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        
    }
    
    func updateFrameSlide(videoRangeSlider: ABVideoRangeSlider, startIndicator: CGFloat, endIndicator: CGFloat) {
        
    }
}
