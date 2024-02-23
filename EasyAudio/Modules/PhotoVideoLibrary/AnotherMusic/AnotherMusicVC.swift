
//
//  
//  AnotherMusicVC.swift
//  EasyAudio
//
//  Created by haiphan on 06/02/2024.
//
//
import UIKit
import RxCocoa
import RxSwift
import Photos

protocol AnotherMusicDelegate: AnyObject {
    func selectesPHAsset(values: [PHAsset])
}

class AnotherMusicVC:  UIViewController, SetupTableView {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: AnotherMusicVM = AnotherMusicVM()
    private var sources: BehaviorRelay<[PHAsset]> = BehaviorRelay(value: [])
    
    weak var delegate: AnotherMusicDelegate?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AnotherMusicVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        setupTableView(tableView: tableView,
                       delegate: self,
                       name: AnotherMusicCell.self)
        let values = ManageApp.shared.convertToPHAsset(photos: ManageApp.shared.getAnotherPhotos())
        sources.accept(values)
    }
    
    private func setupRX() {
        
        sources.asDriverOnErrorJustComplete()
            .map({ values in
                return values.map {
                    return AnotherMediaModel(title: $0.originalFilename,
                                             size: "\(ByteCountFormatter.string(fromByteCount: Int64($0.getSize()), countStyle: .file))") }
            })
            .drive(tableView.rx.items(cellIdentifier: AnotherMusicCell.identifier,
                                         cellType: AnotherMusicCell.self)) { (index, element, cell) in
                cell.setModel(model: element)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                guard let indexs = owner.tableView.indexPathsForSelectedRows else {
                    return
                }
                let values = indexs.map({ owner.sources.value.safe[$0.row] }).compactMap{ $0 }
                owner.delegate?.selectesPHAsset(values: values)
            }.disposed(by: disposeBag)
    }
}
extension AnotherMusicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
