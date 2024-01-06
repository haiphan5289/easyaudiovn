//
//  FeaturesView.swift
//  EasyAudio
//
//  Created by haiphan on 06/01/2024.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class FeaturesView: UIView, SetupBaseCollection {
    
    enum FeatureType: Int, CaseIterable {
        case add
        case merge
        case recording
        case wifi
        case mute
        
        var title: String? {
            switch self {
            case .add: return "Add Audio/Video"
            case .merge: return "Merge Audio/Video"
            case .recording: return "Recording"
            case .wifi: return "Import Wifi"
            case .mute: return "Mute Audio/Video"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .add: return Asset.icPhotoLibrary.image
            case .merge: return Asset.icAddMusic.image
            case .recording: return Asset.icRec.image
            case .wifi: return Asset.icWifi.image
            case .mute: return Asset.icMute.image
            }
        }
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var autoStarTime: Disposable?
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRX()
    }
    
}

extension FeaturesView {
    
    private func setupUI() {
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: FeatureCell.self)
        startTimer()
    }
    
    private func setupRX() {
        Observable.just(FeatureType.allCases)
            .bind(to: self.collectionView.rx.items(cellIdentifier: FeatureCell.identifier, cellType: FeatureCell.self)) { row, data, cell in
                cell.bindValue(type: data)
            }.disposed(by: disposeBag)
    }
    
    private func startTimer() {
        autoStarTime?.dispose()
        autoStarTime = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollAutomatically()
            })
        
    }
    
    func scrollAutomatically() {
        for cell in self.collectionView.visibleCells {
            let indexPath: IndexPath? = self.collectionView.indexPath(for: cell)
            if ((indexPath?.row)! < FeatureType.allCases.count - 1) {
                let indexPath1: IndexPath
                indexPath1 = IndexPath.init(row: (indexPath?.row ?? 0) + 1, section: (indexPath?.section ?? 0))

                self.collectionView.scrollToItem(at: indexPath1, at: .right, animated: true)
            }
            else{
                self.collectionView.contentOffset = .zero
            }

        }
    }
    
}
extension FeaturesView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
