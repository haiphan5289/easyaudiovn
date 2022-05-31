
//
//  
//  ImportWifiVC.swift
//  EasyAudio
//
//  Created by haiphan on 31/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

protocol ImportWifiDelegate: AnyObject {
    func addURL(url: URL)
}

class ImportWifiVC: BaseVC {
    
    var delegate: ImportWifiDelegate?
    
    // Add here outlets
    @IBOutlet weak var lbNameIP: UILabel!
    
    // Add here your view model
    private var viewModel: ImportWifiVM = ImportWifiVM()
    private var wifiManager = SGWiFiUploadManager.shared()
    
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
        self.setupServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.wifiManager?.stopHTTPServer()
    }
    
}
extension ImportWifiVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Import Wifi"
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController(animated: true, nil)
        }.disposed(by: self.disposeBag)
    }
    
    private func setupServer() {
        
        let success = wifiManager?.startHTTPServer(atPort: 4) ?? false
        if success {
            wifiManager?.setFileUploadStartCallback({ (filname, savePath) in
                print("File %@ Upload Start \(filname ?? "")")
            })

            wifiManager?.setFileUploadProgressCallback({ (fileName, savePath, progress) in
                print("File %@ on progress %f \(fileName ?? "") -- \(progress)")
            })

            wifiManager?.setFileUploadFinishCallback({ [weak self] (fileName, savePath) in
                guard let wSelf = self else { return }
                if let filePath = savePath {
                    let url = URL(fileURLWithPath: filePath)
                    wSelf.navigationController?.popViewController(animated: true, {
                        wSelf.delegate?.addURL(url: url)
                    })
                    
                }
                
            })
        }
        
        if let ip = wifiManager?.ip(), let port = wifiManager?.port() {
            let text = "\(ip):\(port)"
            self.lbNameIP.text = text
        }
    }
}
