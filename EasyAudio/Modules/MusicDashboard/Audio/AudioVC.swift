
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
import VisionKit

class AudioVC: UIViewController, BaseAudioProtocol {
    
    struct Constant {
        static let heightCell: CGFloat = 90
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btAdd: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var containerFeatureView: UIView!
    private let featureView: FeaturesView = .loadXib()
    
    // Add here your view model
    private var viewModel: AudioVM = AudioVM()
    private let sources: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    private var filter: FilterVC.FilterType = .accessedDateDescending
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.getURLs()
    }
    
}
extension AudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
        
        self.containerFeatureView.addSubview(featureView)
        featureView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let urlSample = Bundle.main.url(forResource: "video_select_print", withExtension: ".mp4")
//            if let url = urlSample {
//                ManageApp.shared.videos.append(url)
//            }
//        }
        
        ConstantApp.FolderName.allCases.forEach { folder in
            AudioManage.shared.createFolder(path: folder.rawValue, success: nil, failure: nil)
        }
        AudioManage.shared.removeFilesFolder(folderName: ConstantApp.FolderName.folderImport.rawValue)
        AudioManage.shared.removeFilesFolder(folderName: ConstantApp.FolderName.folderEdit.rawValue)
//        AudioManage.shared.removeFilesFolder(folderName: ConstantApp.shared.folderRecording)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.viewModel.sourceURLs.bind { [weak self] list in
            guard let wSelf = self else { return }
            list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
            let list = ManageApp.shared.sortUrl(urls: list, filterType: AppSettings.filterType)
            wSelf.sources.accept(list)
        }.disposed(by: self.disposeBag)
        
        self.sources.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element, filterType: self.filter)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let urlFile = wSelf.sources.value[idx.row]
            wSelf.moveToPlayMusic(item: urlFile)
        }.disposed(by: disposeBag)
        
        self.btAdd.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            let vc = ActionHomeVC.createVC()
            vc.delegate = wSelf
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            wSelf.present(vc, animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        filterButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentFilter(filterType: owner.filter, delegate: owner)
            }.disposed(by: disposeBag)
    }
    
    private func moveToEdit(url: URL) {
        let vc = MixAudioVC.createVC()
        vc.hidesBottomBarWhenPushed = true
        vc.inputURL = url
        self.navigationController?.pushViewController(vc, completion: nil)
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
        case .wifi:
            let vc = ImportWifiVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case .merge:
            let vc = MergeFilesVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .mute:
            let vc = MuteFileVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .effective:
            self.showAlert(title: nil, message: "This feature is coming soon")
        case .videFromPhotos: break
//        case .handlingMusic:
//            let viewcontroller = HandlingMusicVC.createVC()
//            viewcontroller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewcontroller, animated: true)
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
extension AudioVC: FilterDelegate {
    func selectFilter(filterType: FilterVC.FilterType) {
        self.filter = filterType
        viewModel.getURLs()
    }
}
extension AudioVC: ImportWifiDelegate {
    func addURL(url: URL) {
        self.moveToEdit(url: url)
    }
}
extension AudioVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        self.moveToEdit(url: url)
    }
}
extension AudioVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL, folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                        wSelf.moveToEdit(url: outputURL)
                    }
                }
            }
        }
    }
    
}
extension AudioVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        self.convertFromCloud(videoURL: first) { [weak self] outputURL in
            guard let self = self else { return }
            self.moveToEdit(url: outputURL)
        }
//        SVProgressHUD.show()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            AudioManage.shared.encodeVideo(folderName: ConstantApp.FolderName.folderEdit.rawValue, videoURL: first) { outputURL in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    DispatchQueue.main.async {
//                        self.moveToEdit(url: outputURL)
//                        SVProgressHUD.dismiss()
//                    }
//                }
                
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
//            }
//            AudioManage.shared.covertToCAF(folderConvert: ConstantApp.FolderName.folderEdit.rawValue, url: first, type: .caf) { [weak self] outputURLBrowser in
//                guard let wSelf = self else { return }
//                DispatchQueue.main.async {
//                    wSelf.moveToEdit(url: outputURLBrowser)
//                    SVProgressHUD.dismiss()
//                }
//
//            } failure: { [weak self] text in
//                SVProgressHUD.dismiss()
//                guard let wSelf = self else { return }
//                wSelf.showAlert(title: nil, message: text)
//            }
//        }

    }
}
extension AudioVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            // Context menu with title.

            // Use the IndexPathContextMenu protocol to produce the UIActions.
            let rename = self.renameAction(indexPath)
            let shareAction = self.shareAction(indexPath)
            let deleteAction = self.deleteAction(indexPath)

            return UIMenu(title: "",
                          children: [rename,
                                     shareAction,
                                     deleteAction])
        })
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
extension AudioVC: IndexPathContextMenu {
    func deleteFolderPerform(_ indexPath: IndexPath) {
        
    }
    
    func renameActionPerform(_ indexPath: IndexPath) {
        let url = self.sources.value[indexPath.row]
        self.moveToRename(url: url, delegate: self)
    }
    
    func editActionPerform(_ indexPath: IndexPath) {
        
    }
    
    func starActionPerform(_ indexPath: IndexPath) {
        
    }
    
    func duplicateActionPerform(_ indexPath: IndexPath) {
        
    }
    
    func saveToCameraActionPerform(_ indexPath: IndexPath) {
        
    }
    
    func moveToTrashActionPerform(_ indexPath: IndexPath) {
        
    }
    
    func deleteAcionPerform(_ indexPath: IndexPath) {
        let url = self.sources.value[indexPath.row]
        AudioManage.shared.deleteFile(filePath: url)
        self.viewModel.getURLs()
    }
    
    func shareActionPerform(_ indexPath: IndexPath) {
        let url = self.sources.value[indexPath.row]
        self.presentActivty(url: url)
    }
    
}
extension AudioVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
extension AudioVC: RenameProtocol {
    func changeNameSuccess() {
        viewModel.getURLs()
    }
    
    
}
