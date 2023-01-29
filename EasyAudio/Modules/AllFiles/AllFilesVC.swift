
//
//  
//  AllFilesVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/01/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import EasyBaseCodes
import EasyBaseAudio

class AllFilesVC: UIViewController, BaseAudioProtocol {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    
    // Add here your view model
    private var viewModel: AllFilesVM = AllFilesVM()
    private let sources: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.getURLs()
    }
    
}
extension AllFilesVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.viewModel.sourceURLs
            .bind { [weak self] list in
                guard let wSelf = self else { return }
                list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
                let list = ManageApp.shared.sortUrl(urls: list, filterType: AppSettings.filterType)
                wSelf.sources.accept(list)
            }.disposed(by: self.disposeBag)
        
        self.sources
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let urlFile = wSelf.sources.value[idx.row]
            wSelf.moveToPlayMusic(item: urlFile)
        }.disposed(by: disposeBag)
        
        sortButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let vc = FilterVC.createVC()
                vc.filterType = AppSettings.filterType
                vc.delegate = owner
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
    }
}
extension AllFilesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AudioVC.Constant.heightCell
    }
}
extension AllFilesVC: FilterDelegate {
    func selectFilter(filterType: FilterVC.FilterType) {
        AppSettings.filterType = filterType
        viewModel.getURLs()
    }
}
