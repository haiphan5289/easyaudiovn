
//
//  
//  CheckUIVC.swift
//  EasyAudio
//
//  Created by haiphan on 30/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class CheckUIVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var tf1: UITextField!
    
    // Add here your view model
    private var viewModel: CheckUIVM = CheckUIVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension CheckUIVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tf1.becomeFirstResponder()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
