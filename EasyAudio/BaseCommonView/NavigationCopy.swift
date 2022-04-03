//
//  BaseNavigationViewController.swift
//  Audio
//
//  Created by paxcreation on 3/30/21.
//

import UIKit
import RxSwift
import RxCocoa

class NavigationCopy: UIViewController {
    
    let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let buttonRight = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let btSetting = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    
    var titleLarge: String = ""
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        setupNavigation()
    }
    
    private func setupNavigation() {
        self.buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        self.buttonLeft.setTitle("Cancel", for: .normal)
        self.buttonLeft.setTitleColor(Asset.primary.color, for: .normal)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        self.buttonRight.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        self.buttonRight.setImage(Asset.icSearchArrow.image, for: .normal)
        let rightBarButton = UIBarButtonItem(customView: self.buttonRight)
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupRX() {
        self.buttonLeft.rx.tap.bind { _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposebag)
    }
    
}
