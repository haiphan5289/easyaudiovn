
//
//  
//  AudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 04/04/2022.
//
//
import UIKit
import RxCocoa
import RxSwift

class AudioVC: UIViewController {
    
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    private var viewModel: AudioVM = AudioVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension AudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.tableView.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        self.tableView.delegate = self
        
        let urlSample = Bundle.main.url(forResource: "video_select_print", withExtension: ".mp4")
        if let url = urlSample {
            ManageApp.shared.audios.append(url)
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        ManageApp.shared.$audios.bind { [weak self] list in
            guard let wSelf = self else { return }
            print("===== \(list.count)")
        }.disposed(by: self.disposeBag)
        
        ManageApp.shared.$audios.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: AudioCell.identifier, cellType: AudioCell.self)) {(row, element, cell) in
                cell.setupValue(url: element)
            }.disposed(by: disposeBag)
    }
}
extension AudioVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
