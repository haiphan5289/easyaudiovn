
//
//  
//  SettingVC.swift
//  EasyAudio
//
//  Created by haiphan on 01/09/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseAudio

class SettingVC: UIViewController {
    
    enum StatusSetting: Int, CaseIterable {
        case term, privacy, version, aboutMe
        
        var text: String {
            switch self {
            case .term: return "Term"
            case .privacy: return "Privacy"
            case .version: return "Version"
            case .aboutMe: return "About Me"
            }
        }
        
        var img: UIImage? {
            switch self {
            case .term: return  Asset.icTerm.image
            case .privacy: return Asset.icPrivacy.image
            case .version: return Asset.icVersion.image
            case .aboutMe: return Asset.icAboutMe.image
            }
        }
        
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: SettingVM = SettingVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension SettingVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(SettingCell.nib, forCellReuseIdentifier: SettingCell.identifier)
        self.tableView.delegate = self
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        Observable.just(StatusSetting.allCases)
            .bind(to: tableView.rx.items(cellIdentifier: SettingCell.identifier, cellType: SettingCell.self)) {(row, element, cell) in
                cell.setValue(type: element)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, idx in
                let item = StatusSetting.allCases[idx.row]
                switch item {
                case .privacy, .term: AudioManage.shared.openLink(link: ConstantApp.shared.linkPrivacy)
                case .aboutMe:
                    let vc = AboutMeVC.createVC()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                case .version: break
                }
            }.disposed(by: disposeBag)
    }
}
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
