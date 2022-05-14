//
//  TabbarVC.swift
//  EasyAudio
//
//  Created by haiphan on 03/04/2022.
//

import UIKit
import RxSwift


class TabbarVC: UITabBarController {
    
    enum TabbarItems: Int, CaseIterable {
        case audio, video, setting
        
        var viewController: UIViewController {
            switch self {
            case .audio: return AudioVC.createVC()
            case .video: return AudioVC.createVC()
            case .setting: return AudioVC.createVC()
            }
        }
        
        var image: UIImage? {
            switch self {
            case .audio: return Asset.icAudio.image
            case .video: return Asset.icVideo.image
            case .setting: return Asset.icSettings.image
            }
        }
        
        var text: String {
            switch self {
            case .audio:
                return "Audio"
            case .video:
                return "Video"
            case .setting:
                return "Settings"
            }
        }
    }

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension TabbarVC {
    
    private func setupUI() {
        self.tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = Asset.appColor.color
        UITabBar.appearance().barTintColor = .gray
        //self.view.backgroundColor = Asset.colorApp.color
        if #available(iOS 15.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        self.viewControllers = TabbarItems.allCases.map { $0.viewController }
        
        TabbarItems.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            if let vc = wSelf.viewControllers?[type.rawValue] {
                vc.tabBarItem.title = type.text
                vc.tabBarItem.image = type.image
            }
        }
    }
    
    private func setupRX() {
    }
    

}
