//
//  MenuImportFileVC.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 14/01/2024.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices
import EasyBaseAudio
import SVProgressHUD
import VisionKit

class MenuImportFileVC: UIViewController, SetupBaseCollection, BaseAudioProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }

}
extension MenuImportFileVC {
    
    private func setupUI() {
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: MenuImportFileCell.self)
        collectionView.contentInset = UIEdgeInsets(horizontal: 16, vertical: 16)
        title = "Danh mục"
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupRX() {
        Observable.just(AdditionAudioVC.Action.allCases)
            .bind(to: collectionView.rx
                .items(cellIdentifier: MenuImportFileCell.identifier, cellType: MenuImportFileCell.self)) { index, item, cell in
                    cell.setMenu(menu: item)
                }
                .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected.bind { [weak self] idx in
            guard let self = self,
                  let typpe = AdditionAudioVC.Action(rawValue: idx.row) else {
                return
            }
            self.action(action: typpe)
        }.disposed(by: self.disposeBag)
    }
    
    private func moveToEdit(url: URL) {
        self.dismiss(animated: true) {
            if let topVC = ManageApp.shared.getTopViewController() {
                let vc = MixAudioVC.createVC()
                vc.hidesBottomBarWhenPushed = true
                vc.inputURL = url
                topVC.navigationController?.pushViewController(vc, completion: nil)
            }
        }
    }
    
    func action(action: AdditionAudioVC.Action) {
        guard let topvc = ManageApp.shared.getTopViewController() else {
            return
        }
        switch action {
        case .photoLibrary:
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = ["public.movie"]
            vc.delegate = self
            topvc.present(vc, animated: true, completion: nil)
        case .iCloud:
            let types = [kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG2Video]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            //                        documentPicker.shouldShowFileExtensions = true
            topvc.present(documentPicker, animated: true, completion: nil)
        case .recording, .audio:
            let vc = AudioImportVC.createVC()
            if action == .recording {
                vc.folderName = ConstantApp.FolderName.folderRecording.rawValue
            } else {
                vc.folderName = ConstantApp.FolderName.folderAudio.rawValue
            }
            
            vc.delegate = self
            topvc.present(vc, animated: true, completion: nil)
        case .wifi:
            let vc = ImportWifiVC.createVC()
            vc.hidesBottomBarWhenPushed = true
            vc.delegate = self
            topvc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
//extension MenuImportFileVC: FilterDelegate {
//    func selectFilter(filterType: FilterVC.FilterType) {
//        self.filter = filterType
//        viewModel.getURLs()
//    }
//}
extension MenuImportFileVC: ImportWifiDelegate {
    func addURL(url: URL) {
        self.moveToEdit(url: url)
    }
}
extension MenuImportFileVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        self.moveToEdit(url: url)
    }
}
extension MenuImportFileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension MenuImportFileVC: UIDocumentPickerDelegate {
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
extension MenuImportFileVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32 - 16) / 2
        return CGSize(width: width, height: 100)
    }
}
