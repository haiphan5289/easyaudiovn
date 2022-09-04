
//
//  
//  AboutMeVC.swift
//  EasyAudio
//
//  Created by haiphan on 04/09/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class AboutMeVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var lbFacebook: UILabel!
    @IBOutlet weak var btFaceBook: UIButton!
    @IBOutlet weak var btClose: UIButton!
    
    // Add here your view model
    private var viewModel: AboutMeVM = AboutMeVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AboutMeVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        lbFacebook.attributedText = NSAttributedString(string: lbFacebook.text ?? "",
                                                       attributes:
                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.btClose.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
