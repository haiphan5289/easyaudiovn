
//
//  
//  AllMediaVC.swift
//  EasyAudio
//
//  Created by haiphan on 07/02/2024.
//
//
import UIKit
import RxCocoa
import RxSwift

class AllMediaVC: BasePhotoVC {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: AllMediaVM = AllMediaVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AllMediaVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        let values = ManageApp.shared.convertToPHAsset(photos: ManageApp.shared.getAllPhotos())
        self.setValues(values: values)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
