//
//  BaseNavigationSimpleVC.swift
//  Note
//
//  Created by haiphan on 06/10/2021.
//

import Foundation
import UIKit
import RxSwift

class BaseNavigationSimple: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
    }
}
