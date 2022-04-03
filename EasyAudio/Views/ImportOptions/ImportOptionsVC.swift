//
//  ImportOptionsVC.swift
//  Audio
//
//  Created by haiphan on 3/28/21.
//

import UIKit
import RxSwift
import RxCocoa

class ImportOptionsVC: UIViewController {
    
    enum TapImportOption {
        case wifi, icloud, voice, appleMusic, photosAlbum
    }

    var tapImportOption: ((TapImportOption) -> Void)?
    
    @IBOutlet var tapOutSide: UITapGestureRecognizer!
    @IBOutlet weak var btiCloudFile: UIButton!
    @IBOutlet weak var btAppleMusic: UIButton!
    @IBOutlet weak var btWifi: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapOutSide.rx.event.bind { _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        let tapiCloud = self.btiCloudFile.rx.tap.map{ TapImportOption.icloud }
        let tapAppleMusic = self.btAppleMusic.rx.tap.map{ TapImportOption.appleMusic }
        let tapWifi = self.btWifi.rx.tap.map{ TapImportOption.wifi }
        
        Observable.merge(tapiCloud, tapAppleMusic, tapWifi).bind(onNext: weakify({ (tap, wSelf) in
            wSelf.dismiss(animated: true, completion: nil)
            wSelf.tapImportOption?(tap)
        })).disposed(by: disposeBag)
        
    }
}
