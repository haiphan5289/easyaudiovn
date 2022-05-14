
//
//  
//  ActionHomeVC.swift
//  EasyAudio
//
//  Created by haiphan on 14/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

protocol ActionHomeDelegate {
    func action(action: ActionHomeVC.Action)
}

class ActionHomeVC: UIViewController {
    
    enum Action: Int, CaseIterable {
        case add, merge, recording, wifi, mute
    }
    
    var delegate: ActionHomeDelegate?
    
    // Add here outlets
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet var views: [UIView]!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var btDismiss: UIButton!
    
    
    // Add here your view model
    private var viewModel: ActionHomeVM = ActionHomeVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension ActionHomeVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.heightBottomView.constant = ConstantApp.shared.getHeightSafeArea(type: .bottom)
        self.views.forEach { v in
            v.layer.cornerRadius = 14
            v.clipsToBounds = true
            v.dropShadow(color: Asset.blackOpacity60.color, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
        }
        
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.btDismiss.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            wSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        Action.allCases.forEach { type in
            let bt = self.bts[type.rawValue]
            bt.rx.tap.bind { [weak self] _ in
                guard let wSelf = self else { return }
                wSelf.dismiss(animated: true) {
                    wSelf.delegate?.action(action: type)
                }
            }.disposed(by: self.disposeBag)
        }
    }
}
