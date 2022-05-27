
//
//  
//  RecordingVC.swift
//  EasyAudio
//
//  Created by haiphan on 14/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio

class RecordingVC: BaseVC {
    
    struct Constant {
        static let moveScroll: CGFloat = 4
        static let miniMeter: CFloat = 50
        static let widthWave: CGFloat = 2
    }
    
    enum Action: Int, CaseIterable {
        case play, pause, stop
    }
    
    // Add here outlets
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var processView: UIView!
    
    // Add here your view model
    private var recording: Recording!
    private var viewModel: RecordingVM = RecordingVM()
    @VariableReplay private var statusRecord: Action = .pause
    private var dbMeter: PublishSubject<Float> = PublishSubject.init()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.removeBorderNavi(bgColor: Asset.lineColor.color)
        self.setupSingleButtonBack()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("======== deinit")
    }
    
}
extension RecordingVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Recording"
        self.recording = Recording(folderName: "\(ConstantApp.shared.folderRecording)")
        self.recording.delegate = self
        do {
            try self.recording.prepare()
        } catch {

        }
        self.bts[Action.play.rawValue].isHidden = false
        self.bts[Action.pause.rawValue].isHidden = true
        self.bts[Action.stop.rawValue].isHidden = true
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        Action.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.statusRecord = type
            }.disposed(by: self.disposeBag)
        }

        self.$statusRecord.asObservable().bind { [weak self] type in
            guard let wSelf = self else { return }
            switch type {
            case .play:
                do {
                    try wSelf.recording.record()
                    wSelf.bts[Action.play.rawValue].isHidden = true
                    wSelf.bts[Action.pause.rawValue].isHidden = false
                    wSelf.bts[Action.stop.rawValue].isHidden = false
                } catch {
                }
            case .pause:
                wSelf.recording.pause()
                wSelf.bts[Action.play.rawValue].isHidden = false
                wSelf.bts[Action.pause.rawValue].isHidden = true
                wSelf.bts[Action.stop.rawValue].isHidden = false
            case .stop:
                wSelf.stopRecording()
            }
        }.disposed(by: self.disposeBag)

        self.dbMeter.bind { [weak self] value in
            guard let wSelf = self else { return }
            wSelf.scrollView.contentOffset.x += Constant.moveScroll
            wSelf.drawWaveView(value: value)
        }.disposed(by: self.disposeBag)
        
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController(animated: true, nil)
        }.disposed(by: self.disposeBag)
    }
    
    private func drawWaveView(value: Float) {
        let f = self.contentView.convert(self.centerView.frame, to: nil)
        let h: CGFloat = CGFloat((value + Constant.miniMeter) * 5)
        let v: UIView = UIView(frame: CGRect(x: f.origin.x, y: (self.processView.frame.height / 2) - (h / 2), width: 2, height: h))
        v.backgroundColor = Asset.appColor.color
        v.clipsToBounds = true
        v.layer.cornerRadius = 1
        self.processView.addSubview(v)
    }
    
    private func stopRecording() {
        print("======= Recording \(self.recording.url)")
        self.recording.stop()
        self.navigationController?.popViewController()
    }
}
extension RecordingVC: RecorderDelegate {
    func audioMeterDidUpdate(_ dB: Float) {
        self.dbMeter.onNext(dB)
    }
}
