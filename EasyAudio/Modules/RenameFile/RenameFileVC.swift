
//
//  
//  RenameFileVC.swift
//  EasyAudio
//
//  Created by haiphan on 30/01/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import EasyBaseAudio

protocol RenameProtocol: AnyObject {
    func changeNameSuccess()
}

class RenameFileVC: BaseVC {
    
    var url: URL?
    var delegate: RenameProtocol?
    // Add here outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var modifyDateLabel: UILabel!
    @IBOutlet weak var accessDateLabel: UILabel!
    @IBOutlet weak var heightBootomButton: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    
    // Add here your view model
    private var viewModel: RenameFileVM = RenameFileVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        title = "Rename File"
        customLeftBarButtonVer2(imgArrow: Asset.icArrowWhite.image)
        navigationBarCustom(font: UIFont.boldSystemFont(ofSize: 18),
                            bgColor: Asset.appColor.color,
                            textColor: .white)
    }
    
}
extension RenameFileVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        guard let url = self.url else {
            return
        }
        nameLabel.text = url.getName()
        sizeLabel.text = "\(url.getSize() ?? 0) MB"
        durationLabel.text = Int(url.getDuration()).getTextFromSecond()
        createdDateLabel.text = url.creation?.covertToString(format: .HHmmEEEEddMMyyyy)
        modifyDateLabel.text = url.contentModification?.covertToString(format: .HHmmEEEEddMMyyyy)
        accessDateLabel.text = url.contentAccess?.covertToString(format: .HHmmEEEEddMMyyyy)
        nameTextField.text = url.getName()
        nameTextField.becomeFirstResponder()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withUnretained(self)
            .bind { owner, _ in
                owner.view.endEditing(true)
            }.disposed(by: disposeBag)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let url = owner.url, let name = owner.nameTextField.text else {
                    return
                }
                Task.init {
                    do {
                        let folder = AudioManage.shared.getNameFolderToCompress(url: url)
                        let newPath = folder + name
                        let result = try await AudioManage.shared.onlyChangeFile(old: url, new: newPath)
                        switch result {
                        case .success(let url):
                            DispatchQueue.main.async {
                                owner.navigationController?.popViewController(animated: true, {
                                    owner.delegate?.changeNameSuccess()
                                })
                            }
                        case .failure(let err):
                            DispatchQueue.main.async {
                                owner.showAlert(title: nil, message: err.localizedDescription)
                            }
                        }
                    } catch let err{
                        DispatchQueue.main.async {
                            owner.showAlert(title: nil, message: err.localizedDescription)
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        let show = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map { KeyboardInfo($0) }
        let hide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map { KeyboardInfo($0) }
        
        Observable.merge(show, hide).bind { [weak self] keyboard in
            guard let wSelf = self else { return }
            wSelf.runAnimate(by: keyboard)
        }.disposed(by: disposeBag)
    }
    
    private func runAnimate(by keyboarInfor: KeyboardInfo?) {
        guard let i = keyboarInfor else {
            return
        }
        let h = i.height
        let d = i.duration
        
        UIView.animate(withDuration: d) {
            self.heightBootomButton.constant = ( h > 0 ) ? h : 16
        }
    }
}
