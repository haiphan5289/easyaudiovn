//
//  BasePhotoVC.swift
//  EasyAudio
//
//  Created by haiphan on 07/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class BasePhotoVC: UIViewController, SetupBaseCollection {
    
    var collectionView: UICollectionView!
    
    weak var delegate: AllLibraryDelegate?
    
    private var selecteds: [Int] = []
    private let selectedTrigger: PublishSubject<Void> = PublishSubject()
    private let souces: BehaviorRelay<[PHAsset]> = BehaviorRelay(value: [])

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
}
extension BasePhotoVC {
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupCollectionView(collectionView: collectionView, delegate: self, name: AllLibraryCell.self)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.collectionView.reloadData()
        }
    }
    
    private func setupRX() {
        souces.asDriverOnErrorJustComplete()
            .map({ values in
                return values.map { return AllLibraryModel(image: $0.getUIImage(),
                                                           time: "\(Int($0.duration).getTextFromSecond())",
                                                           size: "\(ByteCountFormatter.string(fromByteCount: Int64($0.getSize()), countStyle: .file))") }
            })
            .drive(collectionView.rx.items(cellIdentifier: AllLibraryCell.identifier,
                                           cellType: AllLibraryCell.self)) { [weak self] (index, element, cell) in
                guard let self = self else { return }
                cell.setValue(model: element)
                cell.setSelected(isSelected: self.selecteds.contains(where: { $0 == index }))
                cell.tapActionHandler = { [weak self] in
                    guard let self = self else { return }
                    if let index = self.selecteds.firstIndex(where: { $0 == index }) {
                        self.selecteds.remove(at: index)
                    } else {
                        self.selecteds.append(index)
                    }
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    self.selectedTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        selectedTrigger
            .asDriverOnErrorJustComplete()
            .drive { [weak self] _ in
                guard let self = self else { return }
                let values = self.selecteds.map({ self.souces.value.safe[$0] })
                    .compactMap{ $0 }
                self.delegate?.selectesPHAsset(values: values)
                
            }.disposed(by: disposeBag)
    }
    
    func setValues(values: [PHAsset]) {
        souces.accept(values)
    }
    
}
extension BasePhotoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
