
//
//  
//  MusicWorkVC.swift
//  EasyAudio
//
//  Created by haiphan on 30/08/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import MobileCoreServices
import EasyBaseAudio
import SVProgressHUD
import VisionKit

class MusicWorkVC: UIViewController, BaseAudioProtocol {
    
    struct Constant {
        static let heightCell: CGFloat = 90
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: MusicWorkVM = MusicWorkVM()
    private var sourceURLs: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension MusicWorkVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
        self.setSources()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.sourceURLs.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setWork(url: element)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let urlFile = wSelf.sourceURLs.value[idx.row]
            wSelf.moveToPlayMusic(item: urlFile, status: .work)
        }.disposed(by: disposeBag)
    }
    
    private func setSources() {
        let list = [Bundle.main.url(forResource: "Chamber-Concerto-In-D-Major-RV-93-II-Largo-Gerald-Garcia", withExtension: ".mp3"),
                    Bundle.main.url(forResource: "NhacThien-Hoatau_qadg", withExtension: ".mp3"),
                    Bundle.main.url(forResource: "Suite-No-6-In-D-Major-After-BWV-1012-Gigue-Nigel-Nort", withExtension: ".mp3"),
                    Bundle.main.url(forResource: "Chamber-VoUuNhacThien-Hoatau_qkyx", withExtension: ".mp3")]
            .compactMap { $0 }
        self.sourceURLs.accept(list)
    }
    
}
extension MusicWorkVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            // Context menu with title.

            // Use the IndexPathContextMenu protocol to produce the UIActions.
            let shareAction = self.shareAction(indexPath)
            let deleteAction = self.deleteAction(indexPath)

            return UIMenu(title: "",
                          children: [shareAction,
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
extension MusicWorkVC: IndexPathContextMenu {
    func deleteFolderPerform(_ indexPath: IndexPath) {
        
    }
    
    func renameActionPerform(_ indexPath: IndexPath) {
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
    }
    
    func shareActionPerform(_ indexPath: IndexPath) {
        let url = self.sourceURLs.value[indexPath.row]
        self.presentActivty(url: url)
    }
    
}
