//
//  CacheFileVC.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 21/01/2024.
//

import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio
import SVProgressHUD

class CacheFileVC: UIViewController, SetupTableView, BaseAudioProtocol {
    
    enum CacheFileType: Int, CaseIterable {
        case general, cache, photoLarge
    }

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
//        let appSize = self.appSizeInMegaBytes()
//        print("appSize --- \(appSize)")
//        print("FreeSpace --- \(self.getFreeSpace().toMB())")
//        print("getUsedSpace --- \(self.getUsedSpace().toMB())")
//        print("getTotalSpace --- \(self.getTotalSpace().toMB())")
//        print("Size Device --- \(physicalMemory) ")
//        print("deviceRemainingFreeSpace --- \(self.deviceRemainingFreeSpace() ?? 0)")
        
//        self.getCacheFiles()
        // Do any additional setup after loading the view.
        print("cache \(ManageApp.shared.getTotalSizeFileManager(urls: ManageApp.shared.getSpaceType(type: .cachesDirectory)))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Dung lượng & dữ liệu"
        self.navigationController?.isNavigationBarHidden = false
    }
    var physicalMemory: UInt64 {
        return (ProcessInfo().physicalMemory / 1024) / 1024 // in MB
    }
    
}
extension CacheFileVC {
    
    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibWithCellClass: GeneralInfoCell.self)
        tableView.register(nibWithCellClass: CacheCell.self)
        tableView.register(nibWithCellClass: PhotoSizeLargeCell.self)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupRX() {
//        Observable.just([1]).bind(to: tableView.rx.items(cellIdentifier: GeneralInfoCell.identifier,
//                                                           cellType: GeneralInfoCell.self)) { (index, element, cell) in
//        }.disposed(by: disposeBag)
    }
    
    
}

extension CacheFileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CacheFileType.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = CacheFileType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch type {
        case .general:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoCell.identifier, for: indexPath) as? GeneralInfoCell else {
                return UITableViewCell()
            }
            return cell
        case .cache:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CacheCell.identifier, for: indexPath) as? CacheCell else {
                return UITableViewCell()
            }
            cell.removeCacheHandler = { [weak self] in
                guard let self = self else { return }
                SVProgressHUD.show()
                ManageApp.shared.getSpaceType(type: .cachesDirectory).forEach { url in
                    AudioManage.shared.removeFileAtURLIfExists(url: url)
                }
                SVProgressHUD.dismiss()
            }
            return cell
        case .photoLarge:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoSizeLargeCell.identifier, for: indexPath) as? PhotoSizeLargeCell else {
                return UITableViewCell()
            }
            cell.tapPhotos = { [weak self] in
                guard let self = self else { return }
                self.presentPhotoVideoLarge()
            }
            return cell
        }
    }
}

extension CacheFileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
