//
//  TabbarVC.swift
//  EasyAudio
//
//  Created by haiphan on 03/04/2022.
//

import UIKit
import RxSwift


class TabbarVC: UITabBarController {

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
}
extension TabbarVC {
    
    private func setupRX() {
        self.view.backgroundColor = .white
        
    }
    
    private func setupUI() {
        
    }
}
