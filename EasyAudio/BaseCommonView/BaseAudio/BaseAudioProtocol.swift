//
//  BaseAudioProtocol.swift
//  EasyAudio
//
//  Created by haiphan on 28/08/2022.
//

import Foundation
import AVFoundation
import SVProgressHUD
import EasyBaseAudio

protocol BaseAudioProtocol {}
extension BaseAudioProtocol {
    
    func moveToRename(url: URL, delegate: RenameProtocol) {
        guard let topvc = ManageApp.shared.getTopViewController() else {
            return
        }
        let vc = RenameFileVC.createVC()
        vc.url = url
        vc.delegate = delegate
        topvc.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentFilter(filterType: FilterVC.FilterType, delegate: FilterDelegate) {
        guard let topvc = ManageApp.shared.getTopViewController() else {
            return
        }
        let vc = FilterVC.createVC()
        vc.filterType = filterType
        vc.delegate = delegate
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        topvc.present(vc, animated: true)
    }
    
    func moveToPlayMusic(item: URL, status: PlayMusicVC.Status = .normal) {
        guard let topvc = ManageApp.shared.getTopViewController() else {
            return
        }
        let vc = PlayMusicVC.createVC()
        vc.url = item
        vc.status = status
        topvc.navigationController?.pushViewController(vc, completion: nil)
    }
    
    func convertFromCloud(videoURL: URL, complention: @escaping ((URL) -> Void)) {
        SVProgressHUD.show()
        //If There isn't convert Mpr, you can ỉncrease time Dispatch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AudioManage.shared.encodeVideo(folderName: ConstantApp.FolderName.folderEdit.rawValue, videoURL: videoURL) { outputURL in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    DispatchQueue.main.async {
                        complention(outputURL)
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func playAudio(audioPlayer: inout AVAudioPlayer) {
        guard let url = Bundle.main.url(forResource: "video_select_print", withExtension: "mp4") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            audioPlayer.prepareToPlay()
            audioPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
