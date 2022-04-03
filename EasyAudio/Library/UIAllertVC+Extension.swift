//
//  UIAllertVC+Extension.swift
//  CanCook
//
//  Created by paxcreation on 2/9/21.
//

import UIKit
import RxSwift
import RxCocoa

extension UIAlertController {
    static func present(viewController: UIViewController, msg: String) -> Observable< Void> {
        return Observable.create { (observe) -> Disposable in
            let alert: UIAlertController = UIAlertController(title: "Thông báo", message: msg, preferredStyle: .alert)
            
            let btCancel: UIAlertAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            alert.addAction(btCancel)
            
//            observe.onNext(())
            
            viewController.present(alert, animated: true, completion: nil)
            return Disposables.create {
//                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
