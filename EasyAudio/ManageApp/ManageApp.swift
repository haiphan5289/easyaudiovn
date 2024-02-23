//
/////  ManageApp.swift
//  baominh_ios
//
//  Created by haiphan on 09/10/2021.
//

import Foundation
import RxSwift
import AVFoundation
import CoreLocation
import UIKit
import Photos
import RxRelay
import EasyBaseAudio

class ManageApp {
    
    struct Constant {
        static let miniSize: Int64 = 50000
    }
    
    struct SKProductModel {
        let productID: ProductID
        let price: NSDecimalNumber
        init(productID: ProductID, price: NSDecimalNumber) {
            self.productID = productID
            self.price = price
        }
        
        func getTextPrice() -> String {
            return "$\(self.price.roundTo())"
        }
    }
    static var shared = ManageApp()
    
    @VariableReplay var audios: [URL] = []
    
    private let disposeBag = DisposeBag()
    private init() {
        //        self.removeAllRecording()
        self.start()    }
    
    func start() {
        self.setupRX()
    }
    
    
    private func setupRX() {
        
        
    }
    
    
    func appSizeInMegaBytes() -> Float64 { // approximate value
        
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
    
    func bytesIn(directory: String) -> Float64? {
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
    
    func getCacheFiles() {
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
    
    func getFreeSpace() -> Int64
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
    
    func getTotalSpace() -> Int64
    {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[FileAttributeKey.systemFreeSize] as! Int64
        } catch {
            return 0
        }
    }
    
    func getUsedSpace() -> Int64
    {
        return getTotalSpace() - getFreeSpace()
    }
    
    func getSpaceType(type: FileManager.SearchPathDirectory) -> [URL] {
        let arrayPaths = FileManager.default.urls(for: type, in: .userDomainMask)
        return arrayPaths
    }
    
    func getTotalSizeFileManager(urls: [URL]) -> Double {
        return urls.map({ $0.getSize() })
            .reduce(0) { partialResult, result in
                return Double(partialResult) + Double(result ?? 0)
            }
    }
    
    func deviceRemainingFreeSpace() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            return nil
        }
        return (freeSize.int64Value / 1024) / 1024 // in MB
    }
    
    func getSizeDeviceType(type: FileAttributeKey) -> Int64?  {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[type] as? NSNumber
        else {
            return nil
        }
        return (freeSize.int64Value / 1024) / 1024 // in MB
    }
    
    func ratioAppSizewithSystem() -> Double? {
        let appsize = appSizeInMegaBytes()
        let system = getSizeDeviceType(type: .systemSize) ?? 1
        return (appsize) * 100 / Double(system)
    }
    
    func getPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
                                             PHAssetMediaType.image.rawValue,
                                             PHAssetMediaType.video.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        return imagesAndVideos
    }
    
    func getAnotherPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
                                             PHAssetMediaType.unknown.rawValue,
                                             PHAssetMediaType.audio.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        return imagesAndVideos
    }
    
    func getAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d || mediaType == %d || mediaType == %d",
                                             PHAssetMediaType.unknown.rawValue,
                                             PHAssetMediaType.video.rawValue,
                                             PHAssetMediaType.audio.rawValue,
                                             PHAssetMediaType.image.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        return imagesAndVideos
    }
    
    func convertToPHAsset(photos: PHFetchResult<PHAsset>) -> [PHAsset] {
        if photos.count <= 0 {
            return []
        }
        
        var values: [PHAsset] = []
        for i in 0..<photos.count - 1 {
            let asset = photos.object(at: i)
            print("size asset \(asset.getSize())")
            if asset.getSize() >= Constant.miniSize {
                values.append(asset)
            }
        }
        return values
    }
    
    func deletePHAsset(values: [PHAsset]) {
        let assetIdentifiers = values.map({ $0.localIdentifier })
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets)
        })
    }
    
    func checkPhotoLibraryPermission() -> Observable<[PHAsset]> {
        return Observable.create { sub in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                     ascending: false)]
                    fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
                                                         PHAssetMediaType.video.rawValue)
                    // Fetch all video assets from the Photos Library as fetch results
                    let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: fetchOptions)
                    
                    // Loop through all fetched results
                    var phAssets: [PHAsset] = []
                    fetchResults.enumerateObjects({ (object, count, stop) in
                        phAssets.append(object)
                    })
                    sub.onNext(phAssets)
                    sub.onCompleted()
                case .denied, .restricted, .notDetermined, .limited:
                    sub.onCompleted()
                @unknown default: break
                }
            }
            return Disposables.create()
        }
    }
    
    func sortUrl(urls: [URL], filterType: FilterVC.FilterType) -> [URL] {
        switch filterType {
        case .createDateDescending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.creation, let date2 = item2.creation {
                    return date1.compare(date2) == ComparisonResult.orderedDescending
                }
                return true
            }
        case .createDateAscending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.creation, let date2 = item2.creation {
                    return date1.compare(date2) == ComparisonResult.orderedAscending
                }
                return true
            }
        case .modifiDateAscending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.contentModification, let date2 = item2.contentModification {
                    return date1.compare(date2) == ComparisonResult.orderedAscending
                }
                return true
            }
        case .modifiDateDescending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.contentModification, let date2 = item2.contentModification {
                    return date1.compare(date2) == ComparisonResult.orderedDescending
                }
                return true
            }
        case .accessedDateDescending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.contentAccess, let date2 = item2.contentAccess {
                    return date1.compare(date2) == ComparisonResult.orderedDescending
                }
                return true
            }
        case .accessDateAscending:
            return urls.sorted { item1, item2 in
                if let date1 = item1.contentAccess, let date2 = item2.contentAccess {
                    print("\(date1) --- \(date2)")
                    return date1.compare(date2) == ComparisonResult.orderedAscending
                }
                return true
            }
        case .nameAscending:
            return urls.sorted { item1, item2 in
                let date1 = item1.getName()
                let date2 = item2.getName()
                return date1.compare(date2) == ComparisonResult.orderedAscending
            }
        case .nameDescending:
            return urls.sorted { item1, item2 in
                let date1 = item1.getName()
                let date2 = item2.getName()
                return date1.compare(date2) == ComparisonResult.orderedDescending
            }
        }
    }
    
    //MARK: DEFAULT VALUE INAPP
    func listRawSKProduct() -> [SKProductModel] {
        var list: [SKProductModel] = []
        let w = SKProductModel(productID: .weekly, price: 0.99)
        let m = SKProductModel(productID: .monthly, price: 1.99)
        let y = SKProductModel(productID: .yearly, price: 9.99)
        list.append(w)
        list.append(m)
        list.append(y)
        return list
    }
    
    func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
}

extension PHAsset {
    func getUIImage() -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageDataAndOrientation(for: self, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    func getSize() -> Int64 {
        let resources = PHAssetResource.assetResources(for: self) // your PHAsset
                  
        var sizeOnDisk: Int64 = 0
                
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
        }
        
        return sizeOnDisk
    }
    
}

extension PHAsset {
    func asyncURL(_ completion: @escaping ((URL?) -> Void)) {
        switch mediaType {
        case .image:
            let options: PHContentEditingInputRequestOptions = .init()
            options.canHandleAdjustmentData = { _ in true }
            requestContentEditingInput(with: options) { editingInput, _ in
                completion(editingInput?.fullSizeImageURL)
            }
        case .video:
            let options: PHVideoRequestOptions = .init()
            options.version = .original
            PHImageManager.default()
                .requestAVAsset(forVideo: self, options: options) { asset, _, _ in
                completion((asset as? AVURLAsset)?.url)
            }
        default:
            completion(nil)
        }
    }
    func asyncImageData(version: PHImageRequestOptionsVersion = .original, completion: @escaping  (Data?, String?, UIImage.Orientation, [AnyHashable : Any]?) -> ()) {
        let options = PHImageRequestOptions()
        options.version = version
        PHImageManager.default()
            .requestImageData(for: self, options: options, resultHandler: completion)
    }
}
extension URL {
    var phAsset: PHAsset? {
        PHAsset.fetchAssets(withALAssetURLs: [self], options: nil).firstObject
    }
}

enum ExportFileAV: Int, CaseIterable {
    case mp3, m4a, wav, m4r, caf, aiff, aifc, aac, flac, mp4
    
    var typeExport: AVFileType {
        switch self {
        case .m4a:
            return .m4a
        case .caf:
            return .caf
        default:
            return .mp4
        }
    }
    
    var nameExport: String {
        switch self {
        case .m4a:
            return "m4a"
        case .m4r:
            return "m4r"
        case .wav:
            return "wav"
        case .caf:
            return "caf"
        case .aiff:
            return "aiff"
        case .aifc:
            return "aifc"
        case .flac:
            return "flac"
        default:
            return "mp4"
        }
    }
    
    var presentName: String {
        switch self {
        case .m4a:
            return AVAssetExportPresetAppleM4A
        case .caf:
            return AVAssetExportPresetPassthrough
        default:
            return AVAssetExportPresetHighestQuality
            
        }
    }
    
    //Export 9
    var defaultExport: String {
        return ".m4a"
    }
    
    var nameUrl: String {
        return "\(self)"
    }
}

class DiskStatus {
    
    //MARK: Formatter MB only
    class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    
    //MARK: Get String Value
    class var totalDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    class var freeDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    class var usedDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
        }
    }
    
    
    //MARK: Get raw value
    class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }
    
    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }
    
    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    
}
extension PHAsset {
    var primaryResource: PHAssetResource? {
        let types: Set<PHAssetResourceType>

        switch mediaType {
        case .video:
            types = [.video, .fullSizeVideo]
        case .image:
            types = [.photo, .fullSizePhoto]
        case .audio:
            types = [.audio]
        case .unknown:
            types = []
        @unknown default:
            types = []
        }

        let resources = PHAssetResource.assetResources(for: self)
        let resource = resources.first { types.contains($0.type)}

        return resource ?? resources.first
    }

    var originalFilename: String {
        guard let result = primaryResource else {
            return "file"
        }

        return result.originalFilename
    }
}
