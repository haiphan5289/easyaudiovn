//
//  MusicDashboardVC.swift
//  EasyAudio
//
//  Created by Hai Phan Thanh on 21/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

class MusicDashboardVC: UIViewController {
    
    enum MusicDashboardType: Int {
        case audio, video, music
    }

    var pageViewController: UIPageViewController?
    
    private var audioVC = AudioVC.createVC()
    private var videoVC = VideoVC.createVCfromStoryBoard(storyboard: .video,
                                                         instantiateViewController: .videoVC)
    private var workVC = MusicWorkVC.createVC()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let page = segue.destination as? UIPageViewController {
            self.pageViewController = page
//            self.pageViewController?.viewcon = [audioVC, videoVC, workVC]
            self.pageViewController?.setViewControllers([audioVC], direction: .reverse, animated: false)
        }
    }
    
}
extension MusicDashboardVC {
    
    private func setupUI() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let selected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(selected, for: .selected)
    }
    
    private func setupRX() {
        segmentControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { owner, _ in
                guard let index = MusicDashboardType(rawValue: owner.segmentControl.selectedSegmentIndex) else {
                    return
                }
                
                switch index {
                case .audio:
                    owner.pageViewController?.setViewControllers([owner.audioVC], direction: .reverse, animated: true)
                case .video:
                    owner.pageViewController?.setViewControllers([owner.videoVC], direction: .forward, animated: true)
                case .music:
                    owner.pageViewController?.setViewControllers([owner.workVC], direction: .forward, animated: true)
                }
                
            }.disposed(by: disposeBag)
    }
    
    func stepToSleep() {
        self.pageViewController?.setViewControllers([self.workVC], direction: .forward, animated: true)
        self.segmentControl.selectedSegmentIndex = 2
    }
}
