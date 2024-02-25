
//
//  
//  AllLibraryVC.swift
//  EasyAudio
//
//  Created by haiphan on 06/02/2024.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio
import Photos

protocol AllLibraryDelegate: AnyObject {
    func selectesPHAsset(values: [PHAsset])
    func deselectPHAsset(value: PHAsset)
}

class AllLibraryVC: BasePhotoVC {
    
    // Add here outlets
    
    
    // Add here your view model
    private var viewModel: AllLibraryVM = AllLibraryVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AllLibraryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.setValues(value: ManageApp.shared.getPhotos())
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
