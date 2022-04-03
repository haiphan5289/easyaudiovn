//
//  BaseNavigationLargeTitle.swift
//  Audio
//
//  Created by paxcreation on 3/26/21.
//

import UIKit
import RxSwift
import RxCocoa

class BaseNavigationLargeTitle: UIViewController {
    
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.myBoldSystemFont(ofSize: 17)]
        setupNavigation()
    }
    
    private func setupNavigation() {
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
        
        title = titleLarge
    }
    
    private func setupRX() {
        self.buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposebag)
    }
    
}
