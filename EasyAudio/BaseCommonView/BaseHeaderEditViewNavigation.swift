//
//  BaseHeaderEditViewNavigation.swift
//  AudioRecord
//
//  Created by haiphan on 17/11/2021.
//

import UIKit
import RxSwift

class BaseHeaderMutilSelectavigation: UIViewController {
    
    let btMore = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    let btImport = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    var heightNavigationBar: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            // MARK: Navigation Bar Customisation
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.myMediumSystemFont(ofSize: 22)]
//        self.navigationController?.navigationBar.barTintColor = Asset.navigationBar.color
        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.sizeToFit()
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        self.heightNavigationBar = navigationBarHeight
    }
    private func setupNavigation() {
        
//        btExport.setImage(Asset.icExportEditAudio.image, for: .normal)
        btMore.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        btMore.setImage(Asset.icMoreActionMulti.image, for: .normal)
        btImport.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
        btImport.setImage(Asset.icImport.image, for: .normal)
        let rightBarButton = UIBarButtonItem(customView: btMore)
        let importBarButton = UIBarButtonItem(customView: btImport)
        
        navigationItem.rightBarButtonItems = [rightBarButton, importBarButton]
    }
}
