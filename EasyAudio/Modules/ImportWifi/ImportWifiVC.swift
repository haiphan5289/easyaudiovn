
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

class ImportWifiVC: BaseVC, SetupBaseCollection {
    
    var delegate: ImportWifiDelegate?
    
    // Add here outlets
    @IBOutlet weak var lbNameIP: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: ImportWifiCell.self)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController(animated: true, nil)
        }.disposed(by: self.disposeBag)
        
        
        Driver.just([1])
            .drive( collectionView.rx
                .items(cellIdentifier: ImportWifiCell.identifier, cellType: ImportWifiCell.self)) { index, item, cell in
                }
                .disposed(by: self.disposeBag)
        
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
extension ImportWifiVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
