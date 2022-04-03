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

class ManageApp {
    
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
    
    private let disposeBag = DisposeBag()
    private init() {
        //        self.removeAllRecording()
        self.start()    }
    
    func start() {
        self.setupRX()
    }
    
    
    private func setupRX() {
        
        
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
