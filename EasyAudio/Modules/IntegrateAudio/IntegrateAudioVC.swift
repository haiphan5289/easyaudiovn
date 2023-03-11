
//
//  
//  IntegrateAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 27/02/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class IntegrateAudioVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: IntegrateAudioVM = IntegrateAudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension IntegrateAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
