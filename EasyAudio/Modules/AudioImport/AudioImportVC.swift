
//
//  
//  AudioImportVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

protocol AudioImportDelegate: AnyObject {
    func selectAudio(url: URL)
}

class AudioImportVC: UIViewController {
    
    struct Constant {
        static let heightCell: CGFloat = 90
    }
    
    var folderName: String = ""
    weak var delegate: AudioImportDelegate?
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btDismiss: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    // Add here your view model
    private var viewModel: AudioImportVM!
    @VariableReplay private var urls: [URL] = []
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AudioImportVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.viewModel = AudioImportVM(folderName: self.folderName)
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
        self.lbTitle.text = ConstantApp.FolderName.folderRecording.rawValue
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.viewModel.$urls.bind { [weak self] list in
            guard let wSelf = self else { return }
            list.isEmpty ? wSelf.tableView.setEmptyMessage(emptyView: EmptyView(frame: .zero)) : wSelf.tableView.restore()
        }.disposed(by: self.disposeBag)
        
        self.viewModel.$urls.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] idx in
            guard let wSelf = self else { return }
            wSelf.dismiss(animated: true) {
                let item = wSelf.viewModel.urls[idx.row]
                wSelf.delegate?.selectAudio(url: item)
            }
        }.disposed(by: disposeBag)
        
        self.btDismiss.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
}
extension AudioImportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
