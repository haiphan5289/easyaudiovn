//
//  SetUpBase.swift
//  Beberia
//
//  Created by haiphan on 07/08/2022.
//  Copyright © 2022 IMAC. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol SetUpFunctionBase {
    func setupUI()
    func setupRX()
}

protocol SetupTableView {
}
extension SetupTableView {
    
    func setupTableView<T: UITableViewCell>(tableView: UITableView, delegate: UITableViewDelegate, name: T.Type) {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = delegate
        tableView.register(nibWithCellClass: T.self)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
protocol SetupBaseCollection {}
extension SetupBaseCollection {
    
    func setupCollectionView<T: UICollectionViewCell>(collectionView: UICollectionView,
                                                 delegate: UICollectionViewDelegate,
                                                 name: T.Type) {
        collectionView.delegate = delegate
        collectionView.register(nibWithCellClass: T.self)
    }
    
}
protocol PlayVideoProtocel{}
extension PlayVideoProtocel {

    func playVideo(url: URL, videoView: UIView, playVideo: inout AVPlayer) {
        playVideo = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: playVideo)
        playerLayer.frame = videoView.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resize
        videoView.layoutIfNeeded()
        playerLayer.layoutIfNeeded()
        videoView.layer.addSublayer(playerLayer)
    }
    
    func play(playVideo: AVPlayer) {
        playVideo.play()
    }
    
    func pauseVideo(playVideo: AVPlayer) {
        playVideo.pause()
    }
}
