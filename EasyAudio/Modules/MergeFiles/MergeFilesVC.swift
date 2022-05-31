
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

class MergeFilesVC: BaseVC {
    
    enum Action: Int, CaseIterable {
        case video, audio
    }
    
    // Add here outlets
    @IBOutlet weak var videoAB: ABVideoRangeSlider!
    @IBOutlet var bts: [UIButton]!
    
    // Add here your view model
    private var currentAction: Action = .video
    private var viewModel: MergeFilesVM = MergeFilesVM()
    
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
    
}
extension MergeFilesVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Merge Files"
        self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
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
        
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController()
        }.disposed(by: self.disposeBag)
    }
    
    private func updateURLVideo(url: URL) {
        self.videoAB.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
        self.videoAB.updateBgColor(colorBg: Asset.appColor.color)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioManage.shared.covertToCAF(folderConvert: ConstantApp.FolderName.folderEdit.rawValue, url: first, type: .caf) { [weak self] outputURLBrowser in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    wSelf.updateURLVideo(url: outputURLBrowser)
                    SVProgressHUD.dismiss()
                }
                
            } failure: { [weak self] text in
                SVProgressHUD.dismiss()
                guard let wSelf = self else { return }
                wSelf.showAlert(title: nil, message: text)
            }
        }

    }
}
