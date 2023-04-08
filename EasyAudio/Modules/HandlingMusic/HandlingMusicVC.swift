
//
//  
//  HandlingMusicVC.swift
//  EasyAudio
//
//  Created by haiphan on 25/03/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class HandlingMusicVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var backButton: UIButton!
    
    // Add here your view model
    private var viewModel: HandlingMusicVM = HandlingMusicVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
}
extension HandlingMusicVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        backButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController()
            }.disposed(by: disposeBag)
    }
}
