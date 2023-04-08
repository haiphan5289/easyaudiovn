
//
//  
//  FilterVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/01/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes

protocol FilterDelegate: AnyObject {
    func selectFilter(filterType: FilterVC.FilterType)
}

class FilterVC: UIViewController {
    
    enum FilterType: Codable {
        case createDateDescending,
             createDateAscending,
             modifiDateDescending,
             modifiDateAscending,
             accessedDateDescending,
             accessDateAscending,
             nameAscending,
             nameDescending
    }
    
    var filterType: FilterType = .createDateDescending
    weak var delegate: FilterDelegate?
    
    // Add here outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightBottom: NSLayoutConstraint!
    @IBOutlet weak var imageCreateSort: UIImageView!
    @IBOutlet weak var createdButton: UIButton!
    @IBOutlet weak var imageUpdateSort: UIImageView!
    @IBOutlet weak var updatedButton: UIButton!
    @IBOutlet weak var imageAccess: UIImageView!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imgName: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    
    // Add here your view model
    private var viewModel: FilterVM = FilterVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension FilterVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        heightBottom.constant = GetHeightSafeArea.shared.getHeight(type: .bottom)
        containerView.clipsToBounds = true
        containerView.layer.setCornerRadius(corner: .verticalTop, radius: 12)
        
        switch filterType {
        case .createDateDescending:
            imageUpdateSort.isHidden = true
            imageAccess.isHidden = true
            imageCreateSort.image = Asset.icSortDescending.image
        case .createDateAscending:
            imageUpdateSort.isHidden = true
            imageAccess.isHidden = true
            imageCreateSort.image = Asset.icSortAscending.image
        case .modifiDateDescending:
            imageCreateSort.isHidden = true
            imageAccess.isHidden = true
            imageUpdateSort.image = Asset.icSortDescending.image
        case .modifiDateAscending:
            imageCreateSort.isHidden = true
            imageAccess.isHidden = true
            imageUpdateSort.image = Asset.icSortAscending.image
        case .accessedDateDescending, .accessDateAscending:
            imageCreateSort.isHidden = true
            imageUpdateSort.isHidden = true
            imageAccess.image = (filterType == .accessedDateDescending) ? Asset.icSortDescending.image : Asset.icSortAscending.image
        case .nameAscending, .nameDescending:
            imgName.image = (filterType == .nameDescending) ? Asset.icSortDescending.image : Asset.icSortAscending.image
        }
        
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        createdButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.filterType = (owner.filterType == .createDateDescending) ? .createDateAscending : .createDateDescending
                owner.dismiss(animated: true) {
                    owner.delegate?.selectFilter(filterType: owner.filterType)
                }
            }.disposed(by: disposeBag)
        
        updatedButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.filterType = (owner.filterType == .modifiDateDescending) ? .modifiDateAscending : .modifiDateDescending
                owner.dismiss(animated: true) {
                    owner.delegate?.selectFilter(filterType: owner.filterType)
                }
            }.disposed(by: disposeBag)
        
        accessButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.filterType = (owner.filterType == .accessedDateDescending) ? .accessDateAscending : .accessedDateDescending
                owner.dismiss(animated: true) {
                    owner.delegate?.selectFilter(filterType: owner.filterType)
                }
            }.disposed(by: disposeBag)
        
        nameButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.filterType = (owner.filterType == .nameDescending) ? .nameAscending : .nameDescending
                owner.dismiss(animated: true) {
                    owner.delegate?.selectFilter(filterType: owner.filterType)
                }
            }.disposed(by: disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
