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

class CacheFileVC: UIViewController, SetupTableView {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
        let appSize = self.appSizeInMegaBytes()
        print("appSize --- \(appSize)")
        print("FreeSpace --- \(self.getFreeSpace().toMB())")
        print("getUsedSpace --- \(self.getUsedSpace().toMB())")
        print("getTotalSpace --- \(self.getTotalSpace().toMB())")
        print("Size Device --- \(physicalMemory) ")
        print("deviceRemainingFreeSpace --- \(self.deviceRemainingFreeSpace() ?? 0)")
        
        self.getCacheFiles()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Dung lượng & dữ liệu"
    }
    var physicalMemory: UInt64 {
        return (ProcessInfo().physicalMemory / 1024) / 1024 // in MB
    }

    func deviceRemainingFreeSpace() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemSize] as? NSNumber
        else {
            return nil
        }
        return (freeSize.int64Value / 1024) / 1024 // in MB
    }
    
}
extension CacheFileVC {
    
    private func setupUI() {
        setupTableView(tableView: tableView,
                       delegate: self,
                       name: GeneralInfoCell.self)
    }
    
    private func setupRX() {
        Observable.just([1,2]).bind(to: tableView.rx.items(cellIdentifier: GeneralInfoCell.identifier,
                                                           cellType: GeneralInfoCell.self)) { (index, element, cell) in
            cell.backgroundColor = .red
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
extension CacheFileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
