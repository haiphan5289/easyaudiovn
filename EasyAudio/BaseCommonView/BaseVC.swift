//
//  BaseVC.swift
//  EasyAudio
//
//  Created by haiphan on 14/05/2022.
//

import Foundation
import UIKit
import RxSwift

class BaseVC: UIViewController {
    let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let buttonPlus = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let btSearch = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    var titleLarge: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.myBoldSystemFont(ofSize: 17)]
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            if let navBar = self.navigationController {
                let bar = navBar.navigationBar
                bar.standardAppearance = appearance
                bar.scrollEdgeAppearance = appearance
            }

        }
    }
    
    func removeBorderNavi(bgColor: UIColor = Asset.appColor.color, textColor: UIColor = .black, font: UIFont = UIFont.myBoldSystemFont(ofSize: 17)) {
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
//            self.navigationController?.hideHairline()
        }
    }
    
    func setupNavi(bgColor: UIColor = Asset.appColor.color, textColor: UIColor = .black, font: UIFont = UIFont.myBoldSystemFont(ofSize: 17)) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor,
                                                                        NSAttributedString.Key.font: font]
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
            }
        }
    }
    
    func setupSingleButtonBack() {
        buttonLeft.setImage(Asset.icBack.image, for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        navigationItem.leftBarButtonItem = leftBarButton
    }

}
