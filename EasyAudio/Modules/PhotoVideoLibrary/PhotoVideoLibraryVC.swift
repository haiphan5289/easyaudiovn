
//
//  
//  PhotoVideoLibraryVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/01/2024.
//
//
import UIKit
import RxCocoa
import RxSwift

class PhotoVideoLibraryVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: PhotoVideoLibraryVM = PhotoVideoLibraryVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension PhotoVideoLibraryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
