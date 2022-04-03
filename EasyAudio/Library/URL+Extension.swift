//
//  URL+Extension.swift
//  Audio
//
//  Created by paxcreation on 4/12/21.
//

import Foundation
import UIKit
import MediaPlayer

extension URL {
    func getNameAudio() -> String {
//        let lastPath = self.lastPathComponent
//        let endIndex = lastPath.index(lastPath.endIndex, offsetBy: -4)
//        let name = String(lastPath.prefix(upTo: endIndex))
        return self.deletingPathExtension().lastPathComponent
    }
    
    func getThumbnailImage() -> UIImage? {
        let asset: AVAsset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    func getDuration() -> Double {
        let asset = AVURLAsset(url: self)
        let durationInSeconds = asset.duration.seconds
        return durationInSeconds
    }
    
    func getName() -> String {
        return self.deletingPathExtension().deletingPathExtension().lastPathComponent 
    }
    
    func getDate() -> String {
        return self.deletingPathExtension().pathExtension
    }
    
    func getType() -> String? {
        return self.pathExtension
    }
    
    func removeType() -> String {
        return self.deletingPathExtension().lastPathComponent
    }
    
    func getSize() -> Double? {
        let filePath = self.path
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                let value = size.doubleValue / 1000000.0
                return Double(round(1000 * value) / 1000)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    
    func timeAgo() -> String? {
        guard let d = self.creation else {
            return nil
        }
        return d.getElapsedInterval()
    }
    
    func parseURLSystem() -> URL {
        let nameFolder = ManageApp.shared.detectPathFolder(url: self)
        let url = ManageApp.shared.gettURL(folder: nameFolder)
        return url
    }
    
    func getCreateDate() -> Date? {
        do {
            let resources = try self.parseURLSystem().resourceValues(forKeys: [.creationDateKey])
            return resources.creationDate
        } catch {
            print(error)
        }
        return nil
    }
    func getModifyDate() -> Date? {
        do {
            let resources = try self.parseURLSystem().resourceValues(forKeys: [.contentModificationDateKey])
            return resources.contentModificationDate
        } catch {
            print(error)
        }
        return nil
    }
    
    func getSubURL() -> String {
        let create = self.getCreateDate()?.covertToString(format: .HHmmddMMyyyy)
        var getSize: String = ""
        
        do {
            if let size = try self.parseURLSystem().sizeOnDisk() {
                getSize = size
            }
        } catch {}
        
        return "\(create ?? "") • \(getSize)"
    }
    
    func getURLFolderNew() -> String {
        let url = self.parseURLSystem()
        let create = url.getCreateDate()?.covertToString(format: .HHmmddMMyyyy)
        let list = ManageApp.shared.getItemsFolders(folder: url)
        let total = list.map { $0.getSize() }.compactMap { $0 }.reduce(0, { partialResult, value in partialResult + value }).rounded(toPlaces: 2)
        return "\(create ?? "") • \(total)MB"
    }
    
    func getURLFolder() -> String {
        let url = self.parseURLSystem()
        let create = url.getCreateDate()?.covertToString(format: .HHmmddMMyyyy)
        let getSize = self.getSize()
        return "\(create ?? "") • \(getSize ?? 0)MB"
    }
    
    func getNamePath() -> String {
        return ManageApp.shared.detectPathFolder(url: self)
    }
    
    func getNamePathPlus() -> String {
        return ManageApp.shared.detectPathFolder(url: self) + "/"
    }
}

extension URL {
    /// The time at which the resource was created.
    /// This key corresponds to an Date value, or nil if the volume doesn't support creation dates.
    /// A resource’s creationDateKey value should be less than or equal to the resource’s contentModificationDateKey and contentAccessDateKey values. Otherwise, the file system may change the creationDateKey to the lesser of those values.
    var creation: Date? {
        get {
            return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.creationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently modified.
    /// This key corresponds to an Date value, or nil if the volume doesn't support modification dates.
    var contentModification: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentModificationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently accessed.
    /// This key corresponds to an Date value, or nil if the volume doesn't support access dates.
    ///  When you set the contentAccessDateKey for a resource, also set contentModificationDateKey in the same call to the setResourceValues(_:) method. Otherwise, the file system may set the contentAccessDateKey value to the current contentModificationDateKey value.
    var contentAccess: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentAccessDateKey]))?.contentAccessDate
        }
        // Beginning in macOS 10.13, iOS 11, watchOS 4, tvOS 11, and later, contentAccessDateKey is read-write. Attempts to set a value for this file resource property on earlier systems are ignored.
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentAccessDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
extension URL {
    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }

    /// returns total allocated size of a the directory including its subFolders or not
    func directoryTotalAllocatedSize(includingSubfolders: Bool = false) throws -> Int? {
        guard try isDirectoryAndReachable() else { return nil }
        if includingSubfolders {
            guard
                let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            return try urls.lazy.reduce(0) {
                    (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0) + $0
            }
        }
        return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy.reduce(0) {
                 (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                    .totalFileAllocatedSize ?? 0) + $0
        }
    }

    /// returns the directory total size on disk
    func sizeOnDisk() throws -> String? {
        guard let size = try directoryTotalAllocatedSize(includingSubfolders: true) else { return nil }
        URL.byteCountFormatter.countStyle = .file
        guard let byteCount = URL.byteCountFormatter.string(for: size) else { return nil}
        return byteCount
    }
    private static let byteCountFormatter = ByteCountFormatter()
    
    
}
