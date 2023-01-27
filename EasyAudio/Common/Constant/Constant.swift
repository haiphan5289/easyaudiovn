//
//  Constant.swift
//  CameraMakeUp
//
//  Created by haiphan on 22/09/2021.
//

import Foundation
import UIKit

final class ConstantApp {
    
    enum FolderName: String, CaseIterable {
        case folderImport, folderRecording, folderEdit, folderAudio, folderVideo
    }
    
    static var shared = ConstantApp()
    
    private init() {}
    
    let server: String = ""
    let linkPrivacy: String = "https://sites.google.com/view/naungonhai/trang-ch%E1%BB%A7"
    let linkFb: String = "https://www.facebook.com/hai.hai.7399/"

    func getHeightSafeArea(type: GetHeightSafeArea.SafeAreaType) -> CGFloat {
        return GetHeightSafeArea.shared.getHeight(type: type)
    }
    
}
