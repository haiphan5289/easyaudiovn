
//
//  
//  MixAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class MixAudioVC: BaseVC {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: MixAudioVM = MixAudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
        self.setupNavi(bgColor: .white, textColor: .black, font: UIFont.myBoldSystemFont(ofSize: 18))
    }
    
}
extension MixAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Mix Audio"
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
