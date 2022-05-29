
//
//  
//  AudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 04/04/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import MobileCoreServices
import EasyBaseAudio
import SVProgressHUD

class AudioVC: UIViewController {
    
    struct Constant {
        static let heightCell: CGFloat = 90
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btAdd: UIButton!
    
    // Add here your view model
    private var viewModel: AudioVM = AudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension AudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let urlSample = Bundle.main.url(forResource: "video_select_print", withExtension: ".mp4")
            if let url = urlSample {
                ManageApp.shared.audios.append(url)
            }
        }
        
        AudioManage.shared.createFolder(path: ConstantApp.shared.folderImport, success: nil, failure: nil)
        AudioManage.shared.createFolder(path: ConstantApp.shared.folderRecording, success: nil, failure: nil)
        AudioManage.shared.removeFilesFolder(folderName: ConstantApp.shared.folderImport)
//        AudioManage.shared.removeFilesFolder(folderName: ConstantApp.shared.folderRecording)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        ManageApp.shared.$audios.bind { [weak self] list in
            guard let wSelf = self else { return }
            list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
        }.disposed(by: self.disposeBag)
        
        ManageApp.shared.$audios.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element)
            }.disposed(by: disposeBag)
        
        self.btAdd.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            let vc = ActionHomeVC.createVC()
            vc.delegate = wSelf
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            wSelf.present(vc, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
}
extension AudioVC: ActionHomeDelegate {
    func action(action: ActionHomeVC.Action) {
        switch action {
        case .add:
            let vc = AdditionAudioVC.createVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        case .recording:
            let vc = RecordingVC.createVC()
            self.navigationController?.pushViewController(vc, completion: nil)
        case .merge, .mute, .wifi: break
        }
    }
}
extension AudioVC: AdditionAudioDelegate {
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
        case .recording:
            let vc = AudioImportVC.createVC()
            vc.folderName = ConstantApp.shared.folderRecording
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        case .wifi: break
        }
    }
}
extension AudioVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        let vc = MixAudioVC.createVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, completion: nil)
    }
}
extension AudioVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
    //            ManageApp.shared.secureCopyItemfromLibrary(at: imageURL, folderName: ConstantApp.shared.folderPhotos) { outputURL in
    //                picker.dismiss(animated: true) {
    //                    ManageApp.shared.createFolderModeltoFiles(url: outputURL)
    //                }
    //            } failure: { [weak self] text in
    //                guard let wSelf = self else { return }
    //                wSelf.msgError.onNext(text)
    //            }
//                let vc = ImportFilesVC.createVC()
//                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .overFullScreen
//                vc.inputURL = imageURL
//                self.present(vc, animated: true, completion: nil)

            }
        }
    }
    
}
extension AudioVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioManage.shared.covertToCAF(folderConvert: ConstantApp.shared.folderImport, url: first, type: .caf) { [weak self] outputURLBrowser in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
//                    wSelf.imports.append(outputURLBrowser)
//                    wSelf.tableView.reloadData()
//                    SVProgressHUD.dismiss()
//                    wSelf.playAudio(url: outputURLBrowser, rate: 1, currentTime: 0)
                }
                
            } failure: { [weak self] text in
                SVProgressHUD.dismiss()
                guard let wSelf = self else { return }
                wSelf.showAlert(title: nil, message: text)
            }
        }

    }
}
extension AudioVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
