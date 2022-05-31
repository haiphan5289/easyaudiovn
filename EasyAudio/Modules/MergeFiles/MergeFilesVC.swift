
//
//  
//  MergeFilesVC.swift
//  EasyAudio
//
//  Created by haiphan on 31/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class MergeFilesVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: MergeFilesVM = MergeFilesVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension MergeFilesVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
