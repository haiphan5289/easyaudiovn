
//
//  
//  AllFilesVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/01/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import EasyBaseAudio
import VisionKit

class AllFilesVC: UIViewController, BaseAudioProtocol {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var icBumopImage: UIImageView!
    
    // Add here your view model
    private var viewModel: AllFilesVM = AllFilesVM()
    private let sources: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    
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
extension AllFilesVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.viewModel.sourceURLs
            .bind { [weak self] list in
                guard let wSelf = self else { return }
                list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
                let list = ManageApp.shared.sortUrl(urls: list, filterType: AppSettings.filterType)
                wSelf.sources.accept(list)
            }.disposed(by: self.disposeBag)
        
        self.sources
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element, filterType: AppSettings.filterType)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let urlFile = wSelf.sources.value[idx.row]
            wSelf.moveToPlayMusic(item: urlFile)
        }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentFilter(filterType: AppSettings.filterType, delegate: owner)
            }.disposed(by: disposeBag)
        
    }
}
extension AllFilesVC: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AudioVC.Constant.heightCell
    }
}
extension AllFilesVC: FilterDelegate {
    func selectFilter(filterType: FilterVC.FilterType) {
        AppSettings.filterType = filterType
        viewModel.getURLs()
    }
}
extension AllFilesVC: RenameProtocol {
    func changeNameSuccess() {
        viewModel.getURLs()
    }
}
extension AllFilesVC: IndexPathContextMenu {
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
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
