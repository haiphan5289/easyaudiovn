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
        let appSize = self.appSizeInMegaBytes()
        print("appSize --- \(appSize)")
        print("FreeSpace --- \(self.getFreeSpace().toMB())")
        print("getUsedSpace --- \(self.getUsedSpace().toMB())")
        print("getTotalSpace --- \(self.getTotalSpace().toMB())")
        
        self.getCacheFiles()
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
                    owner.tabBarController?.selectedIndex = TabbarVC.TabbarItems.work.rawValue
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
                default: break
                }
            }.disposed(by: disposeBag)
    }
    
    private func appSizeInMegaBytes() -> Float64 { // approximate value

        // create list of directories
        var paths = [Bundle.main.bundlePath] // main bundle
        let docDirDomain = FileManager.SearchPathDirectory.documentDirectory
        let docDirs = NSSearchPathForDirectoriesInDomains(docDirDomain, .userDomainMask, true)
        if let docDir = docDirs.first {
            paths.append(docDir) // documents directory
        }
        let libDirDomain = FileManager.SearchPathDirectory.libraryDirectory
        let libDirs = NSSearchPathForDirectoriesInDomains(libDirDomain, .userDomainMask, true)
        if let libDir = libDirs.first {
            paths.append(libDir) // library directory
        }
        paths.append(NSTemporaryDirectory() as String) // temp directory

        // combine sizes
        var totalSize: Float64 = 0
        for path in paths {
            if let size = bytesIn(directory: path) {
                totalSize += size
            }
        }
        return totalSize / 1000000 // megabytes
    }

    private func bytesIn(directory: String) -> Float64? {
        let fm = FileManager.default
        guard let subdirectories = try? fm.subpathsOfDirectory(atPath: directory) as NSArray else {
            return nil
        }
        let enumerator = subdirectories.objectEnumerator()
        var size: UInt64 = 0
        while let fileName = enumerator.nextObject() as? String {
            do {
                let fileDictionary = try fm.attributesOfItem(atPath: directory.appending("/" + fileName)) as NSDictionary
                size += fileDictionary.fileSize()
            } catch let err {
                print("err getting attributes of file \(fileName): \(err.localizedDescription)")
            }
        }
        return Float64(size)
    }
    
    private func getCacheFiles() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
//        let cachesDirectory: URL = paths[0]
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let application = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let music = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let video = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)
        print("paths \(paths)")
        print("docs \(docs)")
        print("application \(application)")
        print("music \(music)")
        print("video \(video)")
//        let getSize = docs.map({ $0.sizeOnDisk() }).reduce(0) { partialResult, result in
//            return partialResult + (result ?? 0)
//        }
//        print("getSize \(getSize)")
        
        docs.forEach { url in
            do {
                let size = try url.sizeOnDisk()
                print("get size disk \(size)")
            } catch {
            }
        }
        
        if let first = docs.first {
//            let name = AudioManage.shared.getNamefromURL(url: "folderVideo")
             let items = AudioManage.shared.getItemsFolder(folder: "folderVideo")
            let folder = AudioManage.shared.getUrlFolder(folder: "folderVideo")
            print()
        }
        
    }
    
    private func getFreeSpace() -> Int64
        {
            do
            {
                let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())

                return attributes[FileAttributeKey.systemFreeSize] as! Int64
            }
            catch
            {
                return 0
            }
        }

        private func getTotalSpace() -> Int64
        {
            do {
                let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
                return attributes[FileAttributeKey.systemFreeSize] as! Int64
            } catch {
                return 0
            }
        }

        private func getUsedSpace() -> Int64
        {
            return getTotalSpace() - getFreeSpace()
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
