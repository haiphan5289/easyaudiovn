
//
//  
//  VideoVC.swift
//  EasyAudio
//
//  Created by haiphan on 25/06/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import MobileCoreServices
import EasyBaseAudio
import SVProgressHUD
import VisionKit

class VideoVC: UIViewController, BaseAudioProtocol {
    
    struct Constant {
        static let numberOfCellisThree: CGFloat = 3
        static let spacingCell: CGFloat = 8
    }
    
    enum OpenFrom {
        case dashboard, mute
    }
    
    var openFrom: OpenFrom = .dashboard
    
    // Add here outlets
    @IBOutlet weak var btAction: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    // Add here your view model
    private var viewModel: VideoVM = VideoVM()
    private var filter: FilterVC.FilterType = .accessedDateDescending
    private var sources: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    private var sizeCell: CGSize = CGSize.zero
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getURLs()
        self.navigationController?.isNavigationBarHidden = self.openFrom == .dashboard
    }
    
}
extension VideoVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.collectionView.register(VideoCell.nib, forCellWithReuseIdentifier: VideoCell.identifier)
        self.collectionView.delegate = self
        self.viewModel.getURLs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let w = ((self.collectionView.bounds.size.width) - (Constant.spacingCell * 2)) / Constant.numberOfCellisThree
            self.sizeCell = CGSize(width: w, height: w)
            self.collectionView.reloadData()
        }) 
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.viewModel.sourceURLs
            .bind { [weak self] list in
                guard let wSelf = self else { return }
                list.isEmpty ? wSelf.collectionView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.collectionView.restore()
                let list = ManageApp.shared.sortUrl(urls: list, filterType: wSelf.filter)
                wSelf.sources.accept(list)
            }.disposed(by: self.disposeBag)
        
        self.sources
            .bind(to: self.collectionView.rx.items(cellIdentifier: VideoCell.identifier, cellType: VideoCell.self)) { row, data, cell in
                cell.setupVideo(videoURL: data)
            }.disposed(by: disposeBag)
        
        self.collectionView
            .rx
            .itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                let item = owner.sources.value[idx.row]
                let vc = PlayMusicVC.createVC()
                vc.url = item
                owner.navigationController?.pushViewController(vc, completion: nil)
            }.disposed(by: disposeBag)
        
        self.btAction.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            let vc = ActionHomeVC.createVC()
            vc.delegate = wSelf
            vc.statusView = .video
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
    
    private func addToFolderVideo(videoURL: URL) {
        AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL,
                                                            folderName: ConstantApp.FolderName.folderVideo.rawValue) { [weak self] outputURL in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.viewModel.getURLs()
            }
        }
    }
    
}
extension VideoVC: FilterDelegate {
    func selectFilter(filterType: FilterVC.FilterType) {
        self.filter = filterType
        viewModel.getURLs()
    }
}
extension VideoVC: ActionHomeDelegate {
    func action(action: ActionHomeVC.Action) {
        switch action {
        case .add:
            let vc = AdditionAudioVC.createVC()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            vc.status = .mute
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
        case .videFromPhotos:
            let viewController = VideoFromPhotosVC.createVC()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
//        case .handlingMusic:
//            let viewcontroller = HandlingMusicVC.createVC()
//            viewcontroller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}
extension VideoVC: AdditionAudioDelegate {
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
extension VideoVC: AudioImportDelegate {
    func selectAudio(url: URL) {
        self.addToFolderVideo(videoURL: url)
    }
}
extension VideoVC: ImportWifiDelegate {
    func addURL(url: URL) {
      self.addToFolderVideo(videoURL: url)
    }
}
extension VideoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            AudioManage.shared.converVideofromPhotoLibraryToMP4(videoURL: videoURL, folderName: ConstantApp.FolderName.folderEdit.rawValue) { [weak self] outputURL in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                      wSelf.addToFolderVideo(videoURL: outputURL)
                    }
                }
            }
        }
    }
    
}
extension VideoVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let first = urls.first else {
            return
        }
        self.convertFromCloud(videoURL: first) { [weak self] outputURL in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.addToFolderVideo(videoURL: outputURL)
                SVProgressHUD.dismiss()
            }
        }
        
//        SVProgressHUD.show()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            AudioManage.shared.covertToCAF(folderConvert: ConstantApp.FolderName.folderEdit.rawValue,
//                                           url: first,
//                                           type: .caf) { [weak self] outputURLBrowser in
//                guard let wSelf = self else { return }
//                DispatchQueue.main.async {
//                    wSelf.addToFolderVideo(videoURL: outputURLBrowser)
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
extension VideoVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return self.sizeCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spacingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.spacingCell
    }
}
