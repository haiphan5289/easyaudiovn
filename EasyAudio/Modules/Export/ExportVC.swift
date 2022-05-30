
//
//  
//  ExportVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class ExportVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: ExportVM = ExportVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension ExportVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
