
//
//  
//  AdditionAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 14/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

protocol AdditionAudioDelegate {
    func action(action: AdditionAudioVC.Action)
}

class AdditionAudioVC: UIViewController {
    
    enum StatusView {
        case other, mute
    }
    
    enum Action: Int, CaseIterable {
        case photoLibrary, iCloud, recording, wifi, audio
        
        var image: UIImage? {
            switch self {
            case .photoLibrary: return Asset.icPhotoLibrary.image
            case .iCloud: return Asset.icIcloud.image
            case .recording: return Asset.icRec.image
            case .wifi: return Asset.icWifi.image
            case .audio: return Asset.icAudio.image
            }
        }
        
        var title: String? {
            switch self {
            case .photoLibrary: return "Photo Library"
            case .iCloud: return "iCloud"
            case .recording: return "Recording"
            case .wifi: return "Wifi"
            case .audio: return "Audio Projects"
            }
        }
        
    }
    var delegate: AdditionAudioDelegate?
    var status: StatusView = .other
    // Add here outlets
    @IBOutlet var views: [UIView]!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var btDismiss: UIButton!
    
    // Add here your view model
    private var viewModel: AdditionAudioVM = AdditionAudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AdditionAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.heightBottomView.constant = ConstantApp.shared.getHeightSafeArea(type: .bottom)
        self.views.forEach { v in
            v.layer.cornerRadius = 14
            v.clipsToBounds = true
            v.dropShadow(color: Asset.blackOpacity60.color, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
        }
        if self.status == .mute {
            self.views[Action.recording.rawValue].isHidden = true
            self.views[Action.audio.rawValue].isHidden = true
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.btDismiss.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            wSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        Action.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.dismiss(animated: true) {
                    wSelf.delegate?.action(action: type)
                }
            }.disposed(by: self.disposeBag)
        }
    }
}
