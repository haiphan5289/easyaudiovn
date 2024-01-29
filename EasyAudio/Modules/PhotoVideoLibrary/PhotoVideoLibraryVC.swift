
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

class PhotoVideoLibraryVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var allButon: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var stackViewButton: UIStackView!
    @IBOutlet weak var contentButtonView: UIView!
    
    // Add here your view model
    private var viewModel: PhotoVideoLibraryVM = PhotoVideoLibraryVM()
    
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
    
}
extension PhotoVideoLibraryVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        makeSelectPhotos()
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
            }.disposed(by: disposeBag)
    }
    
    private func makeSelectPhotos() {
        let attribute = NSMutableAttributedString(string: "Đã chọn: 1",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                               .foregroundColor: UIColor.gray])
        let size = NSAttributedString(string: "\n36,2 MB",
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
