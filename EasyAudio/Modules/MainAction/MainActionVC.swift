//
//  MainActionVC.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 19/11/2023.
//

import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio

protocol MainActionDelegate: AnyObject {
    func moveToSleepMusic()
}

class MainActionVC: BaseVC, SetupTableView {
    
    enum MainActionType: Int, CaseIterable {
        case add, recording, musicToSleep, files, wifi, mute, merge, cache, editVideo
        
        var title: String {
            switch self {
            case .add: return "Thêm Audio/Video"
            case .recording: return "Ghi âm"
            case .musicToSleep: return "Âm thanh"
            case .files: return "Dữ liệu"
//            case .mixAudio: return "Trộn Audio"
            case .wifi: return "Wifi"
            case .mute: return "Mute"
            case .merge: return "Merge"
            case .cache: return "Cache"
            case .editVideo: return "Edit Video"
            }
        }
        
        var description: String {
            switch self {
            case .add: return "Chọn 1 audio/ video để edit"
            case .recording: return "Ghi âm giọng nói của bạn"
            case .musicToSleep: return "Âm thanh giúp bạn dễ ngủ và tập trung làm việc"
            case .files: return "Nơi lưu trữ các file mà bạn đã edit"
//            case .mixAudio: return "Giúp bạn thực hiên nhiều audios lại với nhau"
            case .wifi: return "Xử lý autio khi bạn nhập từ Wifi"
            case .mute: return "Tắt tiếng Audio/Video"
            case .merge: return "Nhập nhiều Audio/ Video"
            case .cache: return "Bộ nhớ đệm"
            case .editVideo: return "Chỉnh sửa video"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .add: return Asset.icMaMusic.image
            case .recording: return Asset.icMaRec.image
            case .musicToSleep: return Asset.icMaSleep.image
            case .files: return Asset.icMaFiles.image
//            case .mixAudio: return Asset.icMaMix.image
            case .wifi: return Asset.icMaWifi.image
            case .mute: return Asset.icMaMute.image
            case .merge: return Asset.icMaMerge.image
            case .cache: return Asset.icMaCache.image
            case .editVideo: return Asset.icMaEditVideo.image
            }
        }
        
    }

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MainActionDelegate?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}
extension MainActionVC {
    
    private func setupUI() {
        setupTableView(tableView: tableView,
                       delegate: self,
                       name: MainActionCell.self)
    }
    
    private func setupRX() {
        Driver.just(MainActionType.allCases)
            .drive(tableView.rx.items(cellIdentifier: MainActionCell.identifier, cellType: MainActionCell.self)) { (index, element, cell) in
                cell.bindType(type: element)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                guard let type = MainActionType(rawValue: idx.row) else {
                    return
                }
                switch type {
                case .mute:
                    let merge = MuteFileVC.createVC()
                    merge.moveActionHandler = { [weak owner] in
                        guard let self = owner else { return }
                        self.tabBarController?.selectedIndex = TabbarVC.TabbarItems.dashboard.rawValue
                        let videoVC = VideoVC.createVCfromStoryBoard(storyboard: .video,
                                                                             instantiateViewController: .videoVC)
                        videoVC.openFrom = .mute
                        self.navigationController?.pushViewController(videoVC)
                    }
                    merge.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(merge, animated: true)
                case .wifi:
                    let merge = ImportWifiVC.createVC()
                    merge.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(merge, animated: true)
                case .files:
                    let merge = AllFilesVC.createVC()
                    merge.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(merge, animated: true)
                case .musicToSleep:
                    owner.tabBarController?.selectedIndex = TabbarVC.TabbarItems.dashboard.rawValue
                case .recording:
                    let merge = RecordingVC.createVC()
                    merge.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(merge, animated: true)
                case .merge:
                    let merge = MergeFilesVC.createVC()
                    merge.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(merge, animated: true)
                case .add:
                    let detailViewController = MenuImportFileVC.createVC()
                        let nav = UINavigationController(rootViewController: detailViewController)
                        // 1
                        nav.modalPresentationStyle = .pageSheet
                        // 2
                        if let sheet = nav.sheetPresentationController {
                            // 3
                            sheet.detents = [.medium()]
                            sheet.prefersScrollingExpandsWhenScrolledToEdge = true

                        }
                        // 4
                    self.present(nav, animated: true, completion: nil)
                case .cache:
                    let cache = CacheFileVC.createVC()
                    cache.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(cache, animated: true)
                default: break
                }
            }.disposed(by: disposeBag)
    }
    
    
    
}
extension MainActionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

extension Int64
{
    func toMB() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: self) as String
    }
}
