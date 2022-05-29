
//
//  
//  MixAudioVC.swift
//  EasyAudio
//
//  Created by haiphan on 29/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import EasyBaseAudio

class MixAudioVC: BaseVC {
    
    struct Constant {
        static let heightAudio: CGFloat = 80
        static let widthTime: Int = 60
    }
    
    var inputURL: URL?
    
    // Add here outlets
    @IBOutlet weak var hBottomView: NSLayoutConstraint!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var widthSV: NSLayoutConstraint!
    @IBOutlet weak var leadingSV: NSLayoutConstraint!
    @IBOutlet weak var leadingAudioView: NSLayoutConstraint!
    @IBOutlet weak var heightAudioSV: NSLayoutConstraint!
    @IBOutlet weak var widthAudioSV: NSLayoutConstraint!
    @IBOutlet weak var widthContent: NSLayoutConstraint!
    @IBOutlet weak var audioStackView: UIStackView!
    // Add here your view model
    private var viewModel: MixAudioVM = MixAudioVM()
    @VariableReplay private var sourcesURL: [MutePoint] = []
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSingleButtonBack()
        self.setupNavi(bgColor: .white, textColor: .black, font: UIFont.myBoldSystemFont(ofSize: 18))
    }
    
}
extension MixAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        title = "Mix Audio"
        self.hBottomView.constant = ConstantApp.shared.getHeightSafeArea(type: .bottom)
        self.leadingSV.constant = UIScreen.main.bounds.width / 2
        self.leadingAudioView.constant = UIScreen.main.bounds.width / 2
        
        if let url = self.inputURL {
            let mutePoint: MutePoint = MutePoint(start: 0, end: Float(url.getDuration()), url: url)
            self.sourcesURL.append(mutePoint)
            self.addViewToStackView(url: url)
        }
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.$sourcesURL.asObservable().bind { [weak self] list in
            guard let wSelf = self else { return }
            wSelf.heightAudioSV.constant = CGFloat(list.count) * Constant.heightAudio
            let maxTime = list.map { $0.getEndTime() }.max() ?? 0
            wSelf.widthAudioSV.constant = CGFloat(Int(maxTime) * Constant.widthTime)
            wSelf.widthContent.constant = CGFloat(Int(maxTime) * Constant.widthTime) + 300
            wSelf.setupTimeLineView(second: Int(maxTime))
        }.disposed(by: self.disposeBag)
        
        self.buttonLeft.rx.tap.bind { [weak self] in
            guard let wSelf = self else { return }
            wSelf.navigationController?.popViewController()
        }.disposed(by: self.disposeBag)
    }
    
    private func setupTimeLineView(second: Int) {
        self.timeStackView.subviews.forEach { v in
            v.removeFromSuperview()
        }
        
        for sec in 0...second {
            let v: UIView = UIView()
            
            let timeView: TimeView = TimeView.loadXib()
            timeView.loadTime(time: sec)
            v.addSubview(timeView)
            timeView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.timeStackView.addArrangedSubview(v)
        }
        self.widthSV.constant = CGFloat(second * Constant.widthTime)
    }
    
    private func addViewToStackView(url: URL) {
        let v: UIView = UIView()
        v.clipsToBounds = true
        let abRangeVideo: ABVideoRangeSlider = ABVideoRangeSlider(frame: .zero)
        self.audioStackView.addArrangedSubview(v)
        v.addSubview(abRangeVideo)
        abRangeVideo.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        abRangeVideo.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            abRangeVideo.setVideoURL(videoURL: url, colorShow: Asset.appColor.color, colorDisappear: Asset.lineColor.color)
            abRangeVideo.updateBgColor(colorBg: Asset.appColor.color)
            abRangeVideo.hideTimeLine(hide: true)
            abRangeVideo.delegate = self
        }
    }
}
extension MixAudioVC: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        
    }
    
    func updateFrameSlide(videoRangeSlider: ABVideoRangeSlider, startIndicator: CGFloat, endIndicator: CGFloat) {
        
    }
}
