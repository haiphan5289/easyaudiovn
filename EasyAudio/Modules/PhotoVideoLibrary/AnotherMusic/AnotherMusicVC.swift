
//
//  
//  AnotherMusicVC.swift
//  EasyAudio
//
//  Created by haiphan on 06/02/2024.
//
//
import UIKit
import RxCocoa
import RxSwift

class AnotherMusicVC: BasePhotoVC {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: AnotherMusicVM = AnotherMusicVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AnotherMusicVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        let values = ManageApp.shared.convertToPHAsset(photos: ManageApp.shared.getAnotherPhotos())
        self.setValues(values: values)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
