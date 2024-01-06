
//
//  
//  EffectAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 02/05/2023.
//
//
import UIKit
import RxCocoa
import RxSwift

class EffectAudioVC: UIViewController, SetupTableView {
    
    enum EffectAudioCellType: Int, CaseIterable {
        case audio, title, effectElement
    }
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: EffectAudioVM = EffectAudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension EffectAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        setupTableView(tableView: self.tableView,
                       delegate: self,
                       name: AudioEffectCell.self)
        tableView.register(nibWithCellClass: TitleAudioEffectCell.self)
        tableView.register(nibWithCellClass: EffectElementCell.self)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        Observable.just([1,2,3])
            .bind(to: tableView.rx.items){(tv, row, item) -> UITableViewCell in
                guard let type = EffectAudioCellType(rawValue: row) else {
                    return UITableViewCell.init()
                }
                switch type {
                case .audio:
                    let cell = tv.dequeueReusableCell(withIdentifier: AudioEffectCell.identifier, for: IndexPath.init(row: row, section: 0)) as! AudioEffectCell
                    return cell
                case .title:
                    let cell = tv.dequeueReusableCell(withIdentifier: TitleAudioEffectCell.identifier, for: IndexPath.init(row: row, section: 0)) as! TitleAudioEffectCell
                    
                    return cell
                case .effectElement:
                    let cell = tv.dequeueReusableCell(withIdentifier: EffectElementCell.identifier, for: IndexPath.init(row: row, section: 0)) as! EffectElementCell
                    return cell
                }
            }.disposed(by: disposeBag)
    }
}
extension EffectAudioVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
