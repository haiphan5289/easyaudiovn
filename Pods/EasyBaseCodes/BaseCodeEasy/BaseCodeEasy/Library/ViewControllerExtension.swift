//
//  ViewControllerExtension.swift
//  Dayshee
//
//  Created by haiphan on 10/30/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import UIKit

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
public extension UIViewController {
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
    
    static func createVCfromStoryBoard() -> Self {
        let vc = UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier:  "\(self)") as! Self
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
    
    func removeBorder(font: UIFont, bgColor: UIColor, textColor: UIColor) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            let atts = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
            appearance.configureWithOpaqueBackground()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = atts
            appearance.backgroundColor = bgColor
            if let navBar = self.navigationController {
                let bar = navBar.navigationBar
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
            }
        } else {
            self.navigationController?.hideHairline()
        }
    }
    
    func navigationBarCustom(font: UIFont,
                             bgColor: UIColor,
                             textColor: UIColor,
                             isTranslucent: Bool = true) {
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor,
                                                                        NSAttributedString.Key.font: font]
        self.setupNavigationBariOS15(font: font,
                                     bgColor: bgColor,
                                     textColor: textColor,
                                     isTranslucent: isTranslucent)
    }
    
    func setupNavigationBariOS15(font: UIFont, bgColor: UIColor, textColor: UIColor, isTranslucent: Bool = true) {
        if #available(iOS 15.0, *) {
            let atts = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = atts
            appearance.backgroundColor = bgColor
            
            if let navBar = self.navigationController {
                let bar = navBar.navigationBar
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
//                bar.compactScrollEdgeAppearance = appearance
            }
            
        }
    }
    
    func setupNavigationVer2() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    func customLeftBarButtonVer2(imgArrow: UIImage){
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setTitleColor(.white, for: .normal)
        buttonLeft.setImage(imgArrow, for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.addTarget(self, action: #selector(handleClickBackNavigation), for: .touchUpInside)
    }
    
    @objc func handleClickBackNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
}

