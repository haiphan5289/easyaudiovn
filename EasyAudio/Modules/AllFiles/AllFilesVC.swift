
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

class AllFilesVC: UIViewController, BaseAudioProtocol {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: AllFilesVM = AllFilesVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.viewModel.sourceURLs.bind { [weak self] list in
            guard let wSelf = self else { return }
            list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
        }.disposed(by: self.disposeBag)
        
        self.viewModel.sourceURLs.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            let urlFile = wSelf.viewModel.sourceURLs.value[idx.row]
            wSelf.moveToPlayMusic(item: urlFile)
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
