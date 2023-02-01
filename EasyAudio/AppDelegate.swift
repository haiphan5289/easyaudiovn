//
//  AppDelegate.swift
//  EasyAudio
//
//  Created by haiphan on 25/03/2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.moveToTabbar()
        UIFont.overrideInitialize()
        //        fatalError("Crash was triggered")
//        checkForceUpdate()
        return true
    }
    
    private func moveToTabbar() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = TabbarVC()
        let navi: UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navi
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func checkForceUpdate() {
        FirebaseManage.share.fetchCloudValues { isP in
            DispatchQueue.main.async {
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                let forceUpdateView: ForceUpdateView = .loadXib()
                window.addSubview(forceUpdateView)
                forceUpdateView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    
}

