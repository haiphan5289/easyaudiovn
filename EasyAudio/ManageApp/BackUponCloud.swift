//
//  BackUponCloud.swift
//  AudioRecord
//
//  Created by haiphan on 18/11/2021.
//

import Foundation

protocol BackupCloudDelegate {
    func update(url: URL)
}

class BackupCloud: NSObject {
    
    var query: NSMetadataQuery!
    var delegate: BackupCloudDelegate?
    
    init(url: URL) {
        super.init()
        self.initialiseQuery(url: url)
        self.addNotificationObservers(url: url)
    }
    func initialiseQuery(url: URL) {
        
        query = NSMetadataQuery.init()
        query.operationQueue = .main
        query.searchScopes = [NSMetadataQueryUbiquitousDataScope]
        query.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, "\(url.lastPathComponent)")
    }
    
    func startBackup(fileURL: URL) throws {
//        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: ConstantApp.shared.backupiCloud) else { return }
//        
//        if !FileManager.default.fileExists(atPath: containerURL.path) {
//            try FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
//        }
//        let backupFileURL = containerURL.appendingPathComponent("\(fileURL.getName() ).\(fileURL.getDate())")
//            .appendingPathExtension(type.nameExport)
//        if FileManager.default.fileExists(atPath: backupFileURL.path) {
//            try FileManager.default.removeItem(at: backupFileURL)
//            try FileManager.default.copyItem(at: fileURL, to: backupFileURL)
//        } else {
//            try FileManager.default.copyItem(at: fileURL, to: backupFileURL)
//        }
//        
//        query.operationQueue?.addOperation({ [weak self] in
//            _ = self?.query.start()
//            self?.query.enableUpdates()
//        })
    }
    
    func addNotificationObservers(url: URL) {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue) { (notification) in
            self.processCloudFiles(url: url)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue) { (notification) in
            self.processCloudFiles(url: url)
        }
    }
    
    @objc func processCloudFiles(url: URL) {
        
        if query.results.count == 0 { return }
        var fileItem: NSMetadataItem?
        var fileURL: URL?
        
        for item in query.results {
            guard let item = item as? NSMetadataItem else { continue }
            guard let fileItemURL = item.value(forAttribute: NSMetadataItemURLKey) as? URL else { continue }
            if fileItemURL.lastPathComponent.contains(url.getName()) {
                fileItem = item
                fileURL = fileItemURL
            }
        }
        
        let fileValues = try? fileURL!.resourceValues(forKeys: [URLResourceKey.ubiquitousItemIsUploadingKey])
        if let fileUploaded = fileItem?.value(forAttribute: NSMetadataUbiquitousItemIsUploadedKey) as? Bool,
           fileUploaded == true, fileValues?.ubiquitousItemIsUploading == false {
            self.delegate?.update(url: url)
        } else if let error = fileValues?.ubiquitousItemUploadingError {
            self.delegate?.update(url: url)
        } else {
            if let fileProgress = fileItem?.value(forAttribute: NSMetadataUbiquitousItemPercentUploadedKey) as? Double {
                self.delegate?.update(url: url)
            }
        }
    }
}
