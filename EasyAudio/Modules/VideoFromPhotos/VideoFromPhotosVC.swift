
//
//  
//  VideoFromPhotosVC.swift
//  EasyAudio
//
//  Created by haiphan on 11/03/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import SVProgressHUD
import SwiftUI

class VideoFromPhotosVC: BaseVC, SetupBaseCollection {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: VideoFromPhotosVM = VideoFromPhotosVM()
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
        self.setupNavi(bgColor: Asset.appColor.color, textColor: .black, font: UIFont.mySystemFont(ofSize: 18))
        viewModel.fetchVideo()
        title = "Video Photos Album"
    }
    
}
extension VideoFromPhotosVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: VideoFromPhotosCell.self)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        viewModel.phAssestTrigger
            .asDriverOnErrorJustComplete()
            .drive { [weak self] list in
                guard let self = self else { return }
                list.isEmpty ? self.collectionView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : self.collectionView.restore()
            }.disposed(by: disposeBag)

        
        viewModel.phAssestTrigger
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(cellIdentifier: VideoFromPhotosCell.identifier,
                                           cellType: VideoFromPhotosCell.self)) {(row, element, cell) in
                cell.bindModel(model: element)
            }.disposed(by: disposeBag)
        
        viewModel.activity
            .asDriver()
            .drive { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
                print("========== isLoading \(isLoading)")
            }.disposed(by: disposeBag)

        
        buttonLeft.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
extension VideoFromPhotosVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
