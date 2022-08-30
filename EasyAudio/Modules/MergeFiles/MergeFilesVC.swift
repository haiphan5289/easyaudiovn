
//
//  
//  MergeFilesVC.swift
//  EasyAudio
//
//  Created by haiphan on 31/05/2022.
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

class MergeFilesVC: BaseVC, BaseAudioProtocol {
    
    enum Action: Int, CaseIterable {
        case video, audio
    }
    
    // Add here outlets
    @IBOutlet weak var audioAB: ABVideoRangeSlider!
    @IBOutlet weak var videoAB: ABVideoRangeSlider!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var btPlay: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btExport: UIButton!
    @IBOutlet weak var btPreview: UIButton!
    
    // Add here your view model
    private var currentAction: Action = .video
    private var viewModel: MergeFilesVM = MergeFilesVM()
    private var videoRange: RangeTimeSlider = RangeTimeSlider.empty
    private var audioRange: RangeTimeSlider = RangeTimeSlider.empty
    private var videoTrigger: PublishSubject<Void> = PublishSubject.init()
    private var audioTrigger: PublishSubject<Void> = PublishSubject.init()
    private var outputURL: URL?
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var detectTime: Disposable?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
        self.setupNavi(bgColor: Asset.appColor.color, textColor: .black, font: UIFont.mySystemFont(ofSize: 18))
    }
    
}
extension MergeFilesVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Merge Files"
        self.videoAB.delegate = self
        self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
        
        self.audioAB.delegate = self
        self.audioAB.updateBgColor(colorBg: Asset.appColor.color)
        self.audioSlider.minimumValue = 0
        self.audioSlider.value = 0
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        Action.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] in
                guard let wSelf = self else { return }
                wSelf.currentAction = type
                let vc = AdditionAudioVC.createVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                wSelf.present(vc, animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        }
        
        Observable.combineLatest(self.videoTrigger, self.audioTrigger).debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] _ in
            guard let wSelf = self else { return }
                SVProgressHUD.show()
                AudioManage.shared.cropVideo(sourceURL: wSelf.videoAB.videoURL,
                                             rangeTimeSlider: wSelf.videoRange,
                                             folderName: ConstantApp.FolderName.folderEdit.rawValue) { cropVideo in
                    AudioManage.shared.trimAudio(sourceURL: wSelf.audioAB.videoURL,
                                                 rangeTimdeSlider: wSelf.audioRange,
                                                 folderName: ConstantApp.FolderName.folderEdit.rawValue) { trimAudio in
                        AudioManage.shared.mergeAudioIntoVideo(videoUrl: cropVideo,
                                                               audioUrl: trimAudio,
                                                               folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                            guard let wSelf = self else { return }
                            DispatchQueue.main.async {
                                wSelf.outputURL = outputURL
                                wSelf.audioSlider.maximumValue = Float(outputURL.getDuration())
                                wSelf.lbTime.text = "\(Int(outputURL.getDuration()).getTextFromSecond())"
                                SVProgressHUD.dismiss()
                            }
                        } failure: { _ in
                            SVProgressHUD.dismiss()
                        }

                    } failure: { _ in
                        SVProgressHUD.dismiss()
                    }

                    print("==== \(cropVideo)")
                } failure: { _ in
                    SVProgressHUD.dismiss()
                }
        }.disposed(by: self.disposeBag)
        
        self.btPlay.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let url = wSelf.outputURL else { return }
            wSelf.playAudio(url: url, currentTime: 0)
            wSelf.audioSlider.value = 0
            wSelf.audioSlider.minimumValue = 0
            wSelf.audioSlider.maximumValue = Float(wSelf.audioPlayer.duration)
        }.disposed(by: self.disposeBag)
        
        self.btExport.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let url = wSelf.outputURL else { return }
            let vc = ExportVC.createVC()
            vc.inputURL = url
            vc.openForm = .video
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: self.disposeBag)
        
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController()
        }.disposed(by: self.disposeBag)
        
        self.btPreview.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let url = owner.outputURL else {
                    return
                }
                owner.moveToPlayMusic(item: url)
            }.disposed(by: disposeBag)
    }
    
    private func playAudio(url: URL, currentTime: CGFloat) {
        
        if self.audioPlayer.isPlaying {
            print("===== self.audioPlayer.rate")
            self.audioPlayer.pause()
            self.btPlay.setImage(Asset.icPlay.image, for: .normal)
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.currentTime = TimeInterval(self.audioSlider.value)
            self.autoRunTime()
            self.btPlay.setImage(Asset.icPause.image, for: .normal)
        } catch {
        }
    }
    
    private func playAudio() {
        self.audioPlayer.play()
        self.autoRunTime()
    }
    
    private func stopAudio() {
        self.audioPlayer.stop()
        self.clearAction()
    }
    
    private func pauseAudio() {
        self.audioPlayer.pause()
        self.clearAction()
    }
    
    private func updateURLVideo(url: URL) {
        if self.currentAction == .video {
            self.videoAB.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
            self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
            self.videoAB.waveForm.isHidden = true
            self.videoAB.updateThumbnails()
            self.videoTrigger.onNext(())
        } else {
            self.audioAB.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
            self.audioAB.updateBgColor(colorBg: Asset.appColor.color)
            self.audioTrigger.onNext(())
        }
        
    }
    private func clearAction() {
        detectTime?.dispose()
    }
    private func autoRunTime() {
        detectTime?.dispose()
        
        detectTime = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] (time) in
                guard let wSelf = self else { return }
                let restTime = Int(wSelf.audioPlayer.duration - wSelf.audioPlayer.currentTime)
                wSelf.lbTime.text = restTime.getTextFromSecond()
                wSelf.audioSlider.value = Float(wSelf.audioPlayer.currentTime)
            })
    }
}
extension MergeFilesVC: AdditionAudioDelegate {
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
        case .recording, .audio:
            let vc = AudioImportVC.createVC()
            if action == .recording {
                vc.folderName = ConstantApp.FolderName.folderRecording.rawValue
            } else {
                vc.folderName = ConstantApp.FolderName.folderAudio.rawValue
            }
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        case .wifi:
            let vc = ImportWifiVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension MergeFilesVC: ImportWifiDelegate {
    func addURL(url: URL) {
        self.updateURLVideo(url: url)
    }
}
extension MergeFilesVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        self.updateURLVideo(url: url)
    }
}
extension MergeFilesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension MergeFilesVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        SVProgressHUD.show()
        self.convertFromCloud(videoURL: first) { [weak self] outputURL in
            guard let self = self else { return }
            self.updateURLVideo(url: outputURL)
        }

    }
}
extension MergeFilesVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPlayer.stop()
        self.btPlay.setImage(Asset.icPlay.image, for: .normal)
        self.clearAction()
        self.audioSlider.value = 0
    }
    
}
extension MergeFilesVC: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        if endTime - startTime <= 2 {
            return
        }
        if videoRangeSlider == self.videoAB {
            self.videoRange = RangeTimeSlider(start: startTime, end: endTime)
            self.videoTrigger.onNext(())
        }
        
        if videoRangeSlider == self.audioAB {
            self.audioRange = RangeTimeSlider(start: startTime, end: endTime)
            self.audioTrigger.onNext(())
        }
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        
    }
    
    func updateFrameSlide(videoRangeSlider: ABVideoRangeSlider, startIndicator: CGFloat, endIndicator: CGFloat) {
        
    }
}
