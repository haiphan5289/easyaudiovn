
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
import Photos

class PhotoVideoLibraryVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var allButon: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var stackViewButton: UIStackView!
    @IBOutlet weak var contentButtonView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var pageViewController: UIPageViewController?
    
    private var allLibrary: AllLibraryVC = AllLibraryVC.createVC()
    private var anotherMusic: AnotherMusicVC = AnotherMusicVC.createVC()
    private var allMedia: AllMediaVC = AllMediaVC.createVC()
    
    // Add here your view model
    private var viewModel: PhotoVideoLibraryVM = PhotoVideoLibraryVM()
    
    private let selectedTrigger: BehaviorRelay<[PHAsset]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Ảnh, video, file lớn hơn 5MB"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let page = segue.destination as? UIPageViewController {
            self.pageViewController = page
            self.pageViewController?.setViewControllers([allMedia], direction: .reverse, animated: false)
        }
    }
    
}
extension PhotoVideoLibraryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        allLibrary.delegate = self
        anotherMusic.delegate = self
        makeSelectPhotos(count: 0, total: "0 MB")
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        imageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var frame = owner.imageButton.convert(owner.contentButtonView.frame,
                                                      to: owner.contentButtonView)
                owner.imageButton.setTitleColor(.black, for: .normal)
                frame.size = CGSize(width: owner.imageButton.frame.width, height: 1)
                owner.moveLineView(frame: frame)
                owner.updateStateButton(buttons: [owner.allButon, owner.fileButton])
                owner.pageViewController?.setViewControllers([owner.allLibrary], direction: .reverse, animated: false)
            }.disposed(by: disposeBag)
        
        allButon.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var frame = owner.allButon.convert(owner.contentButtonView.frame,
                                                      to: owner.contentButtonView)
                owner.allButon.setTitleColor(.black, for: .normal)
                frame.size = CGSize(width: owner.allButon.frame.width, height: 1)
                owner.moveLineView(frame: frame)
                owner.updateStateButton(buttons: [owner.imageButton, owner.fileButton])
                owner.pageViewController?.setViewControllers([owner.allMedia], direction: .reverse, animated: false)
            }.disposed(by: disposeBag)
        
        fileButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                var frame = owner.fileButton.convert(owner.contentButtonView.frame,
                                                      to: owner.contentButtonView)
                owner.fileButton.setTitleColor(.black, for: .normal)
                frame.size = CGSize(width: owner.fileButton.frame.width, height: 1)
                owner.moveLineView(frame: frame)
                owner.updateStateButton(buttons: [owner.imageButton, owner.allButon])
                owner.pageViewController?.setViewControllers([owner.anotherMusic], direction: .reverse, animated: false)
            }.disposed(by: disposeBag)
        
        selectedTrigger
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] values in
                guard let self = self else { return }
                let count = values.count
                let total = values.map{ $0.getSize() }
                    .reduce(0) { partialResult, result in
                        return partialResult + result
                    }
                let strMB = (ByteCountFormatter.string(fromByteCount: total, countStyle: .file))
                self.deleteButton.tintColor = count > 0 ? .red : .gray
                self.deleteButton.isEnabled = count > 0
                self.makeSelectPhotos(count: count, total: strMB)
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                ManageApp.shared.deletePHAsset(values: self.selectedTrigger.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeSelectPhotos(count: Int, total: String) {
        let attribute = NSMutableAttributedString(string: "Đã chọn: \(count)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                               .foregroundColor: UIColor.gray])
        let size = NSAttributedString(string: "\n\(total)",
                                      attributes: [.font: UIFont.boldSystemFont(ofSize: 13),
                                                   .foregroundColor: UIColor.black])
        attribute.append(size)
        selectLabel.attributedText = attribute
    }
    
    private func updateStateButton(buttons: [UIButton]) {
        buttons.forEach { button in
            button.setTitleColor(.gray, for: .normal)
        }
    }
    
    private func moveLineView(frame: CGRect) {
        var frameOrigin = self.lineView.frame
        UIView.animate(withDuration: 0.2) {
            frameOrigin.origin.x = frame.origin.x
            self.lineView.frame = CGRect(origin: frameOrigin.origin, size: CGSize(width: frame.width, height: frameOrigin.height))
        }
    }
    
}
extension PhotoVideoLibraryVC: AllLibraryDelegate {
    func selectesPHAsset(values: [PHAsset]) {
        let list = self.selectedTrigger.value + values
        self.selectedTrigger.accept(list)
    }
}
