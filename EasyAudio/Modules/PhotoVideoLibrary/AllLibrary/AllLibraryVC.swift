
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
}

class AllLibraryVC: UIViewController, SetupBaseCollection {
    
    // Add here outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AllLibraryDelegate?
    
    // Add here your view model
    private var viewModel: AllLibraryVM = AllLibraryVM()
    private var selecteds: [Int] = []
    private let selectedTrigger: PublishSubject<Void> = PublishSubject()
    private let souces: BehaviorRelay<[PHAsset]> = BehaviorRelay(value: [])
    
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
        setupCollectionView(collectionView: collectionView, delegate: self, name: AllLibraryCell.self)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.collectionView.reloadData()
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        souces.accept(ManageApp.shared.convertToPHAsset())
            
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
                let values = selecteds.map({ self.souces.value.safe[$0] })
                    .compactMap{ $0 }
                self.delegate?.selectesPHAsset(values: values)
                
            }.disposed(by: disposeBag)
        
    }
}
extension AllLibraryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
