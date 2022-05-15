
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
    
    enum Action: Int, CaseIterable {
        case play, pause, stop
    }
    
    // Add here outlets
    @IBOutlet var bts: [UIButton]!
    
    // Add here your view model
    private var recording: Recording!
    private var viewModel: RecordingVM = RecordingVM()
    @VariableReplay private var statusRecord: Action?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
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
            guard let wSelf = self, let type = type else { return }
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
                print("======= Recording \(wSelf.recording.url)")
                wSelf.recording.stop()
                wSelf.navigationController?.popViewController()
            }
        }.disposed(by: self.disposeBag)
    }
}
extension RecordingVC: RecorderDelegate {
    func audioMeterDidUpdate(_ dB: Float) {
        
    }
}
