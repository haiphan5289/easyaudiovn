//
//  ViewControllerExtension.swift
//  Dayshee
//
//  Created by haiphan on 10/30/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    /// Reactive wrapper for `setTitle(_:for:)`
//    public loading(for controlState: UIControl.State = []) -> Binder<String?> {
//        Binder(self.base) { button, title in
//            button.setTitle(title, for: controlState)
//        }
//    }
    
    public var rxLoading: Binder<Bool> {
        Binder(self.base) { _, loading in
            loading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }
    }
    
}

protocol Weakifiable: AnyObject {}
extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            code(arg, self)
        }
    }
}
extension UIViewController: Weakifiable {}
extension UIViewController {
    
    enum StoryBoardName: String {
        case video = "VideoVC"
        
        enum InstantiateViewController: String {
            case videoVC = "VideoVC"
        }
        
    }
    
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
    }
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
    static func createVCfromStoryBoard(storyboard: StoryBoardName,
                                       instantiateViewController: StoryBoardName.InstantiateViewController) -> Self {
        let vc = UIStoryboard(name: "\(storyboard.rawValue)",
                              bundle: nil).instantiateViewController(withIdentifier: "\(instantiateViewController.rawValue)") as! Self
        return vc
    }
    
    static func createVC() -> Self {
        let vc = Self.init(nibName: "\(self)", bundle: nil)
        return vc
    }
    
    func presentActivty(url: Any) {
        let objectsToShare: [Any] = [url]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact,
                                            .mail, .message, .postToFacebook, .postToWhatsApp]
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
//            if !completed {
//                return
//            }
            activityVC.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}

