//
//  PhotoSizeLargeCell.swift
//  EasyAudio
//
//  Created by haiphan on 27/01/2024.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class PhotoSizeLargeCell: UITableViewCell {
    
    var tapPhotos: (() -> Void)?

    @IBOutlet weak var stackView: UIStackView!
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupRX()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionView(_ sender: UIButton) {
        self.tapPhotos?()
    }
    private func setupRX() {
        ManageApp.shared.checkPhotoLibraryPermission()
            .asDriverOnErrorJustComplete()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.setupStackView()
            }
            .disposed(by: self.disposeBag)
    }
    
    func setupStackView() {
        stackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let values = ManageApp.shared.convertToPHAsset(photos: ManageApp.shared.getPhotos())
        values.enumerated().forEach { element in
            let asset = element.element
            let offset = element.offset
            if offset <= 3 || values.count <= 5  {
                let photoView: PhotoSizeLargeView = .loadXib()
                photoView.showImage(image: asset.getUIImage())
                photoView.showDuration(duration: asset.getSize())
                stackView.addArrangedSubview(photoView)
            }
            
            if values.count > 5 && offset == 4 {
                let photoView: PhotoSizeLargeView = .loadXib()
                photoView.setCount(count: values.count - 4)
                photoView.viewAllHandler = { [weak self] in
                    guard let self = self else { return }
                    self.tapPhotos?()
                }
                stackView.addArrangedSubview(photoView)
            }
            
        }
        
    }
        
}
