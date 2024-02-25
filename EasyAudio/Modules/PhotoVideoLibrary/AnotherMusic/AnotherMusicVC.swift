
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
    func deselectPHAsset(value: PHAsset)
}

class AnotherMusicVC:  UIViewController, SetupTableView {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: AnotherMusicVM = AnotherMusicVM()
    var allPhotos: PHFetchResult<PHAsset>? = nil
    
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
        tableView.dataSource = self
        allPhotos = ManageApp.shared.getAnotherPhotos()
        checkEmptyView()
    }
    
    private func setupRX() {
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                guard let allPhotos = self.allPhotos else {
                    return
                }
                let values = allPhotos.object(at: idx.row)
                owner.delegate?.selectesPHAsset(values: [values])
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .withUnretained(self)
            .bind { owner, idx in
                guard let allPhotos = self.allPhotos else {
                    return
                }
                let values = allPhotos.object(at: idx.row)
                owner.delegate?.deselectPHAsset(value: values)
            }.disposed(by: disposeBag)
    }
    
    private func checkEmptyView() {
        guard let allPhotos = allPhotos, allPhotos.count <= 0 else {
            return
        }
        let emptyView: EmptyView = EmptyView(frame: .zero, text: "You don't have any data")
        self.tableView.setEmptyMessage(emptyView: emptyView)
    }
    
}
extension AnotherMusicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let allPhotos = self.allPhotos,
              let cell = tableView.dequeueReusableCell(withIdentifier: AnotherMusicCell.identifier, for: indexPath) as? AnotherMusicCell else {
            return UITableViewCell()
        }
        let item = allPhotos.object(at: indexPath.row)
        cell.setModel(asset: item)
        return cell
    }
    
    
}
extension AnotherMusicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
