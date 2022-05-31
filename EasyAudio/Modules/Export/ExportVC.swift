
//
//  
//  ExportVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio

class ExportVC: BaseVC {
    
    
    var inputURL: URL?
    
    // Add here outlets
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var distanceBottom: NSLayoutConstraint!
    @IBOutlet weak var btExport: UIButton!
    
    // Add here your view model
    private var viewModel: ExportVM = ExportVM()
    
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
    }
    
}
extension ExportVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Export File"
        if let url = self.inputURL {
            self.lbSize.text = "\(url.getSize() ?? 0) MB"
            self.lbDuration.text = "\(Int(url.getDuration()).getTextFromSecond())"
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController()
        }.disposed(by: self.disposeBag)
        
        self.btExport.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            guard let name = wSelf.tfName.text, !name.isEmpty, let url = wSelf.inputURL else {
                return
            }
            AudioManage.shared.changeNameFile(folderName: ConstantApp.FolderName.folderAudio.rawValue, oldURL: url, newName: name) { [weak self] outputURL in
                guard let wSelf = self else { return }
                DispatchQueue.main.async {
                    wSelf.navigationController?.popToViewController(ofClass: TabbarVC.self)
                }
            } failure: { text in
                print(text)
            }
            
        }.disposed(by: self.disposeBag)
        
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
            self.distanceBottom.constant = ( h > 0 ) ? h : 16
        }
    }
}
