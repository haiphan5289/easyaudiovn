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
        case mainAction, dashboard, setting
        
//        var viewController: UIViewController {
//            switch self {
//            case .mainAction: return MainActionVC.createVC()
////            case .allFiles: return AllFilesVC.createVC()
//            case .dashboard: return MusicDashboardVC.createVCfromStoryBoard()
////            case .video: return VideoVC.createVCfromStoryBoard(storyboard: .video,
////                                                               instantiateViewController: .videoVC)
////            case .work:  return MusicWorkVC.createVC()
//            case .setting: return SettingVC.createVC()
//            }
//        }
        
        var image: UIImage? {
            switch self {
            case .mainAction: return Asset.icAllFiles.image
//            case .allFiles: return Asset.icAllFiles.image
            case .dashboard: return Asset.icAudio.image
//            case .video: return Asset.icVideo.image
//            case .work: return Asset.icWorking.image
            case .setting: return Asset.icSettings.image
            }
        }
        
        var text: String {
            switch self {
            case .mainAction: return "All Files"
//            case .allFiles:
//                return "All Files"
            case .dashboard:
                return "Dashboard"
//            case .video:
//                return "Video"
            case .setting:
                return "Settings"
//            case .work:
//                return "Work"
            }
        }
    }

    private let mainAction = MainActionVC.createVC()
    private let dashboard = MusicDashboardVC.createVCfromStoryBoard()
    private let setting = SettingVC.createVC()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension TabbarVC {
    
    private func setupUI() {
//        self.delegate = self
        self.tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = Asset.appColor.color
        UITabBar.appearance().barTintColor = Asset.lineColor.color
        //self.view.backgroundColor = Asset.colorApp.color
        if #available(iOS 15.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Asset.lineColor.color
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        mainAction.delegate = self
        self.viewControllers = [mainAction, dashboard, setting]
        
        TabbarItems.allCases.forEach { [weak self] type in
            guard let wSelf = self else { return }
            if let vc = wSelf.viewControllers?[type.rawValue] {
                vc.tabBarItem.title = type.text
                vc.tabBarItem.image = type.image
            }
        }
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found item \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    private func setupRX() {
    }
    

}
extension TabbarVC: MainActionDelegate {
    func moveToSleepMusic() {
        dashboard.stepToSleep()
    }
}
