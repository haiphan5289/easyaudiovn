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
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRX()
        
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
    
    func setupSingleButtonBack() {
        buttonLeft.setImage(Asset.icBack.image, for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupNavigation() {
        buttonLeft.setImage(UIImage(named: "icArrowLeft"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        buttonPlus.setImage(UIImage(named: "icPlus"), for: .normal)
        buttonPlus.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        let rightBarButton = UIBarButtonItem(customView: buttonPlus)
        
        btSearch.setImage(UIImage(named: "icSearch"), for: .normal)
        btSearch.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        let btSeatchBar = UIBarButtonItem(customView: btSearch)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItems = [rightBarButton, btSeatchBar]
        
    }
    
    private func setupRX() {
        self.buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposebag)
    }
}
