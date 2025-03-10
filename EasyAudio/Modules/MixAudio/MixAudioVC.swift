
//
//  
//  MixAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import MobileCoreServices
import EasyBaseAudio
import SVProgressHUD
import AVFoundation

class MixAudioVC: BaseVC, BaseAudioProtocol {
    
    enum Action: Int, CaseIterable {
        case trash, split, add, export
    }
    
    enum ActionMusic: Int, CaseIterable {
        case backWard, play, pause, forWard
    }
    
    struct Constant {
        static let heightAudio: CGFloat = 80
        static let widthTime: Int = 60
        static let spaceMoveScroll: CGFloat = 6
        static let adjustTime: CGFloat = 5
        static let plusMusic: CGFloat = adjustTime * 60
    }
    
    enum IncreaseStatus {
        case normal, finish, start
        
        static func getStatus(currentTime: CGFloat, duration: CGFloat) -> Self {
            if currentTime >= duration {
                return .finish
            }
            
            if currentTime <= 0 {
                return .start
            }
            
            return .normal
        }
    }
    
    struct ScaleVideo {
        let video: ABVideoRangeSlider
        let startTiem: Float64
        let endTime: Float64
    }
    
    var inputURL: URL?
    
    // Add here outlets
    @IBOutlet weak var hBottomView: NSLayoutConstraint!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var widthSV: NSLayoutConstraint!
    @IBOutlet weak var leadingSV: NSLayoutConstraint!
    @IBOutlet weak var leadingAudioView: NSLayoutConstraint!
    @IBOutlet weak var heightAudioSV: NSLayoutConstraint!
    @IBOutlet weak var widthAudioSV: NSLayoutConstraint!
    @IBOutlet weak var widthContent: NSLayoutConstraint!
    @IBOutlet weak var audioStackView: UIStackView!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet var btsMusic: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var fadeInOutButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var effectButton: UIButton!
    // Add here your view model
    private var viewModel: MixAudioVM = MixAudioVM()
    @VariableReplay private var sourcesURL: [MutePoint] = []
    @VariableReplay private var splitAudios: [SplitAudioModel] = []
    private var videoURLs: [ABVideoRangeSlider] = []
//    private var selecAudio: UIView?
    private var exportURL: URL?
    private let detectABVideo: PublishSubject<ScaleVideo> = PublishSubject.init()
    private var updateRangeFrameEvent: PublishSubject<(CGFloat, CGFloat, ABVideoRangeSlider)> = PublishSubject.init()
    private var selectIndex: Int?
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var detectTime: Disposable?
    private let showAlertTrigger: PublishSubject<String> = PublishSubject.init()
    private let showLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setupSingleButtonBack()
//        self.setupNavi(bgColor: Asset.appColor.color, textColor: .black, font: UIFont.mySystemFont(ofSize: 18))
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.finishAudio()
    }
    
    deinit {
        print("=== deinit\(self)")
    }
    
}
extension MixAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Mix Audio"
        self.hBottomView.constant = ConstantApp.shared.getHeightSafeArea(type: .bottom)
        self.leadingSV.constant = UIScreen.main.bounds.width / 2
        self.leadingAudioView.constant = UIScreen.main.bounds.width / 2
        
        if let url = self.inputURL {
            let mutePoint: MutePoint = MutePoint(start: 0, end: Float(url.getDuration()), url: url)
            self.sourcesURL.append(mutePoint)
            self.addViewToStackView(url: url, distanceToLeft: 0)
        }
        
//        let volumeView: VolumeView = .loadXib()
//        self.view.addSubview(volumeView)
//        volumeView.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//        }
//        volumeView.setTitle(title: "Volume")
//        volumeView.actionHanler = { [weak self] volume in
//            guard let self1 = self else { return }
//            let volumeView: VolumeView = .loadXib()
//            self1.view.addSubview(volumeView)
//            volumeView.snp.makeConstraints { make in
//                make.left.bottom.right.equalToSuperview()
//            }
//            volumeView.setTitle(title: "Volume")
//            volumeView.actionHanler = { [weak self] volume in
//                guard let self2 = self else { return }
//                let volumeView: VolumeView = .loadXib()
//                self2.view.addSubview(volumeView)
//                volumeView.snp.makeConstraints { make in
//                    make.left.bottom.right.equalToSuperview()
//                }
//                volumeView.setTitle(title: "Volume")
//                volumeView.actionHanler = { [weak self] volume in
//                    guard let self = self else { return }
//                    
//                    
//                }
//                
//            }
//        }
//        volumeButton.rx.tap
//            .withUnretained(self)
//            .bind { owner, _ in
//                guard let inputURL = owner.exportURL else {
//                    return
//                }
//                let volumeView: VolumeView = .loadXib()
//                owner.view.addSubview(volumeView)
//                volumeView.snp.makeConstraints { make in
//                    make.left.bottom.right.equalToSuperview()
//                }
//                volumeView.setTitle(title: "Volume")
//                volumeView.setupAudioURL(url: inputURL)
//                volumeView.actionHanler = { [weak self] volume in
//                    guard let self = self else { return }
//                    AudioManage.shared.changeVolumeAudio(sourceURL: inputURL,
//                                                         volume: volume,
//                                                         folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
//                        guard let self = self else { return }
//                        self.exportURL = outputURL
//                    } failure: { [weak self] error in
//                        guard let self = self, let text = error?.localizedDescription else { return }
//                        self.showAlertTrigger.onNext(text)
//                    }
//                    volumeView.removeFromSuperview()
//                }
//            }.disposed(by: disposeBag)
        
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        showLoading
            .asDriver()
            .drive(self.rx.rxLoading)
            .disposed(by: self.disposeBag)
        
        self.$sourcesURL.asObservable().bind { [weak self] list in
            guard let wSelf = self else { return }
            wSelf.heightAudioSV.constant = CGFloat(list.count) * Constant.heightAudio
            let maxTime = list.map { $0.getEndTime() }.max() ?? 0
            wSelf.widthAudioSV.constant = CGFloat(Int(maxTime) * Constant.widthTime)
            wSelf.widthContent.constant = CGFloat(Int(maxTime) * Constant.widthTime) + 300
            wSelf.setupTimeLineView(second: Int(maxTime))
        }.disposed(by: self.disposeBag)
        
        self.$splitAudios.asObservable().bind { [weak self] list in
            guard let wSelf = self else { return }
            let l = list.sorted(by: { $0.endSecond > $1.endSecond })
            wSelf.exportURL(list: l)
        }.disposed(by: self.disposeBag)
        
        Action.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] in
                guard let wSelf = self else { return }
                switch type {
                case .add:
                    let vc = AdditionAudioVC.createVC()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.delegate = self
                    wSelf.present(vc, animated: true, completion: nil)
                case .trash:
                    wSelf.deleteAudio()
                case .export:
                    let vc = ExportVC.createVC()
                    vc.inputURL = wSelf.exportURL
                    wSelf.navigationController?.pushViewController(vc, animated: true)
                case .split: break
                }
            }.disposed(by: self.disposeBag)
        }
        
        ActionMusic.allCases.forEach { type in
            let bt = self.btsMusic[type.rawValue]
            bt.rx.tap.bind { [weak self] in
                guard let wSelf = self, let url = wSelf.exportURL else { return }
                switch type {
                case .play:
                    var detectTime = (wSelf.detectCenterView() - UIScreen.main.bounds.width / 2) / CGFloat(Constant.widthTime)
                    if detectTime <= 0 {
                        detectTime = 0
                    }
                    wSelf.playAudio(url: url, currentTime: detectTime)
                    wSelf.btsMusic[ActionMusic.play.rawValue].isHidden = true
                    wSelf.btsMusic[ActionMusic.pause.rawValue].isHidden = false
                    wSelf.autoRunTime()
                case .pause:
                    wSelf.pauseAudio()
                    wSelf.btsMusic[ActionMusic.play.rawValue].isHidden = false
                    wSelf.btsMusic[ActionMusic.pause.rawValue].isHidden = true
                case .backWard, .forWard:
                    var current = wSelf.audioPlayer.currentTime
                    if type == .backWard {
                        current -= Constant.adjustTime
                    } else {
                        current += Constant.adjustTime
                    }
                    wSelf.continueAudio(currenTime: current)
                }
            }.disposed(by: self.disposeBag)
        }
        
        self.detectABVideo
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] scaleVideo in
                guard let self = self else { return }
                let url = scaleVideo.video.videoURL
                let start = scaleVideo.startTiem
                let end = scaleVideo.endTime
                AudioManage.shared.trimmSound(inUrl: url,
                                            index: 1,
                                            start: start,
                                              end: end,
                                              folderSplit: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.inputURL = outputURL
                        let mutePoint: MutePoint = MutePoint(start: 0, end: Float(outputURL.getDuration()), url: outputURL)
                        self.sourcesURL = []
                        self.sourcesURL.append(mutePoint)
                        self.addViewToStackView(url: outputURL, distanceToLeft: 0)
                    }

                } failure: { [weak self] textError in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.showAlert(title: nil, message: textError)
                    }
                }
            }.disposed(by: self.disposeBag)
       
        self.backButton.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController()
        }.disposed(by: self.disposeBag)
        
        volumeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputURL = owner.exportURL else {
                    return
                }
                owner.pauseAudio()
                let volumeView: VolumeView = .loadXib()
                owner.view.addSubview(volumeView)
                volumeView.snp.makeConstraints { make in
                    make.left.bottom.right.equalToSuperview()
                }
                volumeView.setTitle(title: "Volume")
                volumeView.setupAudioURL(url: inputURL)
                volumeView.actionHanler = { [weak owner] volume in
                    guard let self = owner else { return }
                    self.showLoading.accept(true)
                    AudioManage.shared.changeVolumeAudio(sourceURL: inputURL,
                                                         volume: volume,
                                                         folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                        guard let self = self else { return }
                        self.exportURL = outputURL
                        self.showLoading.accept(false)
                    } failure: { [weak self] error in
                        defer {
                            self?.showLoading.accept(false)
                        }
                        guard let self = self, let text = error?.localizedDescription else { return }
                        self.showAlertTrigger.onNext(text)
                    }
                    volumeView.removeFromSuperview()
                }
            }.disposed(by: disposeBag)
        
        fadeInOutButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputURL = owner.exportURL else {
                    return
                }
                owner.pauseAudio()
                let fadeView: FadeInOutView = .loadXib()
                owner.view.addSubview(fadeView)
                fadeView.snp.makeConstraints { make in
                    make.left.bottom.right.equalToSuperview()
                }
                fadeView.setTitle(title: "Fade")
                fadeView.setupAudioURL(url: inputURL)
                fadeView.actionHanler = { [weak owner] fadeIn, fadeOut in
                    guard let self = owner else { return }
                    self.showLoading.accept(true)
                    AudioManage.shared.handleFadeIn(sourceURL: inputURL,
                                                    fadein: fadeIn,
                                                    fadeOut: fadeOut,
                                                    folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                        guard let self = self else { return }
                        self.exportURL = outputURL
                        self.showLoading.accept(false)
                    } failure: { [weak self] error in
                        guard let self = self, let text = error?.localizedDescription else { return }
                        self.showAlertTrigger.onNext(text)
                        self.showLoading.accept(false)
                    }
                    fadeView.removeFromSuperview()
                }
            }.disposed(by: disposeBag)
        
        speedButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let inputURL = owner.exportURL else {
                    return
                }
                owner.pauseAudio()
                let speedView: SpeedView = .loadXib()
                owner.view.addSubview(speedView)
                speedView.snp.makeConstraints { make in
                    make.left.bottom.right.equalToSuperview()
                }
                speedView.setTitle(title: "Speed")
                speedView.setupAudioURL(url: inputURL)
                speedView.actionHanler = { [weak owner] speeed in
                    guard let self = owner else { return }
                    self.showLoading.accept(true)
                    AudioManage.shared.changeRateAudio(url: inputURL,
                                                       speed: speeed,
                                                       folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                        guard let self = self else { return }
                        self.showLoading.accept(false)
                        self.exportURL = outputURL
                    }
                    speedView.removeFromSuperview()
                }
            }.disposed(by: disposeBag)
        
        showAlertTrigger
            .asDriverOnErrorJustComplete()
            .drive { [weak self] error in
                guard let self = self else { return }
                self.showAlert(title: nil, message: error)
            }.disposed(by: disposeBag)
        
        effectButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = EffectAudioVC.createVC()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    private func updateframeWave(position: CGFloat, updateView: UIView, updateViewRange: ABVideoRangeSlider?) {
        var f = updateView.frame
        f.size.width = position
        updateView.frame = f
        if let range = updateViewRange {
            range.frame = f
        }
    }
    
    private func setupTimeLineView(second: Int) {
        self.timeStackView.subviews.forEach { v in
            v.removeFromSuperview()
        }
        
        for sec in 0...second {
            let v: UIView = UIView()
            
            let timeView: TimeView = TimeView.loadXib()
            timeView.loadTime(time: sec)
            v.addSubview(timeView)
            timeView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.timeStackView.addArrangedSubview(v)
        }
        self.widthSV.constant = CGFloat(second * Constant.widthTime)
    }
    
    private func exportURL(list: [SplitAudioModel]) {
        guard let first = list.first, let url = first.url else { return }
        var l = list
        l.removeFirst()
        let audioEffect = AudioEffect()
        let randomIndex = Int.random(in: 0...999999)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            audioEffect.mergeAudiosSplits(musicUrl: url,
                                          timeStart: 0,
                                          timeEnd: first.endSecond,
                                          index: 1,
                                          listAudioProtocol: l,
                                          deplayTime: first.startAudio(),
                                          nameMusic: "\(randomIndex)",
                                          folderName: ConstantApp.FolderName.folderEdit.rawValue,
                                          nameId: AudioManage.shared.parseDatetoString()) { (outputURL, _) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    AudioManage.shared.covertToAudio(url: outputURL, folder: ConstantApp.FolderName.folderEdit.rawValue, type: .m4a) { [weak self] outputURL in
                        guard let wSelf = self else { return }
                        print("====== export \(outputURL)")
                        wSelf.exportURL = outputURL
                    } failure: { [weak self] error in
                        guard let wSelf = self else { return }
                        wSelf.showAlertTrigger.onNext(error)
                    }
                }
            } failure: { [weak self] (err, txt) in
                guard let wSelf = self else { return }
                wSelf.showAlertTrigger.onNext(txt)
            }
        }
    }
    
    private func addViewToStackView(url: URL, distanceToLeft: Int) {
        
        audioStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        self.videoURLs.forEach { v in
            v.hideViews(hide: true)
            v.waveForm.changeColor(isSelect: false)
        }
        
        let v: UIView = UIView()
        let abRangeVideo: ABVideoRangeSlider = ABVideoRangeSlider(frame: .zero)
        self.audioStackView.addArrangedSubview(v)
        v.addSubview(abRangeVideo)
        abRangeVideo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(distanceToLeft > 0 ? distanceToLeft : 10)
            make.width.equalTo((url.getDuration() * Double(Constant.widthTime)) - 40)
        }
        abRangeVideo.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            abRangeVideo.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
            abRangeVideo.updateBgColor(colorBg: Asset.appColor.color)
            abRangeVideo.hideTimeLine(hide: true)
            abRangeVideo.delegate = self
        }
        
        let bt: UIButton = UIButton(type: .custom)
        bt.setTitle(nil, for: .normal)
        v.addSubview(bt)
        bt.snp.makeConstraints { make in
            make.edges.equalTo(abRangeVideo)
        }
        
        let startSecond = distanceToLeft / Constant.widthTime
        let splitAudio: SplitAudioModel = SplitAudioModel(view: v,
                                                          startSecond: CGFloat(startSecond),
                                                          endSecond: Double(startSecond) + url.getDuration(),
                                                          url: url)
        
        bt.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.videoURLs.forEach { v in
                v.hideViews(hide: true)
                v.waveForm.changeColor(isSelect: false)
            }
            abRangeVideo.hideViews(hide: false)
            abRangeVideo.waveForm.changeColor(isSelect: true)
//            wSelf.selecAudio = v
            wSelf.selectIndex(splitView: splitAudio)
        }.disposed(by: self.disposeBag)
        

        self.splitAudios.append(splitAudio)
        self.videoURLs.append(abRangeVideo)
//        self.selecAudio = v
        self.selectIndex(splitView: splitAudio)
    }
    
    private func deleteAudio() {
        guard let index = self.selectIndex, index <= self.sourcesURL.count else {
            return
        }
        self.sourcesURL.remove(at: index)
        let splitAudio = self.splitAudios[index]
        if let index = self.splitAudios.firstIndex(where: { $0.view == splitAudio.view }) {
            self.splitAudios.remove(at: index)
        }
        
        if let index = self.audioStackView.subviews.firstIndex(where: { $0 == splitAudio.view }) {
            self.audioStackView.subviews[index].removeFromSuperview()
        }
    }
    
    private func selectIndex(splitView: SplitAudioModel) {
        if let index = self.splitAudios.firstIndex(where: { $0.view == splitView.view }) {
            self.selectIndex = index
        } else {
            self.selectIndex = nil
        }
    }
    
    private func detectCenterView() -> CGFloat {
        return self.playView.convert(self.centerView.frame, to: nil).origin.x
    }
    
    private func playAudio(url: URL, currentTime: CGFloat) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.currentTime = TimeInterval(currentTime)
            self.autoRunTime()
        } catch {
        }
    }
    
    private func finishAudio() {
        self.scrollView.setContentOffset(.zero, animated: true)
        self.clearAction()
        self.stopAudio()
        self.btsMusic[ActionMusic.play.rawValue].isHidden = false
        self.btsMusic[ActionMusic.pause.rawValue].isHidden = true
    }
    
    private func playAudio() {
        self.audioPlayer.play()
    }
    
    private func stopAudio() {
        self.audioPlayer.stop()
    }
    
    private func pauseAudio() {
        self.audioPlayer.pause()
        self.clearAction()
        self.btsMusic[ActionMusic.play.rawValue].isHidden = false
        self.btsMusic[ActionMusic.pause.rawValue].isHidden = true
    }
    
    private func continueAudio(currenTime: CGFloat) {
        switch IncreaseStatus.getStatus(currentTime: currenTime, duration: self.audioPlayer.duration) {
        case .finish:
            self.audioPlayer.stop()
            self.finishAudio()
        case .start:
            self.audioPlayer.currentTime = TimeInterval(0)
            self.audioPlayer.play()
            self.scrollView.setContentOffset(.zero, animated: true)
        case .normal:
            if currenTime >= self.audioPlayer.currentTime {
                UIView.animate(withDuration: 0.1) {
                    self.scrollView.contentOffset.x += Constant.plusMusic
                } completion: { _ in
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.scrollView.contentOffset.x -= Constant.plusMusic
                } completion: { _ in
                    self.view.layoutIfNeeded()
                }
            }
            self.audioPlayer.currentTime = TimeInterval(currenTime)
            self.audioPlayer.play()
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
                wSelf.autoScrollView()
            })
    }
    
    private func autoScrollView() {
        UIView.animate(withDuration: 0.1) {
            self.scrollView.contentOffset.x += Constant.spaceMoveScroll
        } completion: { _ in
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupURL(url: URL) {
        let startTime: CGFloat = (self.detectCenterView() - UIScreen.main.bounds.width / 2) / CGFloat(Constant.widthTime)
        let mutePoint: MutePoint = MutePoint(start: Float(startTime), end: Float(url.getDuration()), url: url)
        self.sourcesURL.append(mutePoint)
        
        let distanceToLeft: CGFloat = (self.detectCenterView() - UIScreen.main.bounds.width / 2)
        self.addViewToStackView(url: url, distanceToLeft: Int(distanceToLeft))
    }
}
extension MixAudioVC: AdditionAudioDelegate {
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
        case .wifi: break
        }
    }
}
extension MixAudioVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        self.setupURL(url: url)
    }
}
extension MixAudioVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL, folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    wSelf.setupURL(url: outputURL)
                }
            }
        }
    }
    
}
extension MixAudioVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        SVProgressHUD.show()
        self.convertFromCloud(videoURL: first) { [weak self] outputURL in
            guard let self = self else { return }
            self.setupURL(url: outputURL)
        }

    }
}
extension MixAudioVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.finishAudio()
    }
}
extension MixAudioVC: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.detectABVideo.onNext(ScaleVideo(video: videoRangeSlider, startTiem: startTime, endTime: endTime))
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        
    }
    
    func updateFrameSlide(videoRangeSlider: ABVideoRangeSlider, startIndicator: CGFloat, endIndicator: CGFloat) {
        self.updateRangeFrameEvent.onNext((startIndicator, endIndicator, videoRangeSlider))
    }
}
