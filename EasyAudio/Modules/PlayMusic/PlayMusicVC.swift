
//
//  
//  PlayMusicVC.swift
//  EasyAudio
//
//  Created by haiphan on 28/08/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import AVFoundation
//import EasyBaseCodes

class PlayMusicVC: UIViewController, BaseAudioProtocol {
    
    // Add here outlets
    @IBOutlet weak var heighTopView: NSLayoutConstraint!
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var contentAudioView: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var videoFrame: UIView!
    @IBOutlet weak var imgGift: UIImageView!
    private let manageView: ManageAudioView = .loadXib()
    var url: URL?
    
    // Add here your view model
    private var viewModel: PlayMusicVM = PlayMusicVM()
    private var avplayerManager: AVPlayerManager = AVPlayerManager()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.avplayerManager.doAVPlayer(action: .pause)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension PlayMusicVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        self.heightBottomView.constant = GetHeightSafeArea.shared.getHeight(type: .bottom)
        self.heighTopView.constant = GetHeightSafeArea.shared.getHeight(type: .top) + 50
        self.avplayerManager.delegate = self
        self.contentAudioView.addSubview(self.manageView)
        self.manageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.manageView.backgroundColor = Asset.blackOpacity60.color
        self.manageView.bgView.backgroundColor = .clear
        self.manageView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = self.url {
                self.playURL(url: url)
            }
        }
        self.animationView()
        let tapView: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapView)
        tapView.rx.event
            .withUnretained(self)
            .bind { owner, _ in
                owner.animationView()
            }.disposed(by: disposeBag)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
        self.btBack.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController()
            }.disposed(by: disposeBag)
    }
    
    private func loadGift() {
        let random = Int.random(in: 1...12)
        self.imgGift.image = UIImage.gifImageWithName("image_gift_\(random)")
    }
    
    private func animationView() {
        self.contentAudioView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 2) {
                self.contentAudioView.isHidden = true
            }
        }
    }
    
    private func playURL(url: URL) {
        self.avplayerManager.loadVideoURL(videoURL: url, videoView: self.videoFrame)
        self.avplayerManager.doAVPlayer(action: .play)
        self.manageView.updateStatusVideo(stt: .play)
        if url.getThumbnailImage() == nil {
            self.view.layoutIfNeeded()
            self.imgGift.isHidden = false
            self.imgGift.image = self.imgGift.image?.resizeImageSpace(width: self.imgGift.frame.width)
            self.loadGift()
        }
    }
    
    private func updateValueProcess(time: Float) {
        self.manageView.updateValueProcess(time: time)
    }
    
    
    
}
extension PlayMusicVC: ManageAudioViewDelegate {
    
    func setTime(value: Float) {
        self.avplayerManager.doAVPlayer(action: .pause)
        self.avplayerManager.playToTime(value: value)
        self.avplayerManager.doAVPlayer(action: .play)
    }
    
    func selectAction(action: MuteFileVC.ActionMusic) {
        switch action {
        case .play:
            self.avplayerManager.doAVPlayer(action: .play)
        case .pause:
            self.avplayerManager.doAVPlayer(action: .pause)
        case .backWard:
            self.avplayerManager.doAVPlayer(action: .rewind(5))
        case .forWard:
            self.avplayerManager.doAVPlayer(action: .forward(5))
        }
    }
}
extension PlayMusicVC: AVPlayerManagerDelegate {
    func getDuration(value: Double) {
        self.manageView.getDuration(value: value)
    }
    
    func didFinishAVPlayer() {
        self.manageView.updateStatusVideo(stt: .pause)
    }
    
    func timeProcess(time: Double) {
        self.manageView.timeProcess(time: time)
    }
}
extension UIImage {
    func resizeImageSpace(width: CGFloat) -> UIImage? {
        let size = self.size
        
        let width  = width
        let ratio = size.height / size.width
        let height = width * ratio
        
        // Figure out what our orientation is, and use that to form the rectangle
        let newSize: CGSize = CGSize(width: width, height: height)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
//
//  iOSDevCenters+GIF.swift
//  GIF-Swift
//
//  Created by iOSDevCenters on 11/12/15.
//  Copyright © 2016 iOSDevCenters. All rights reserved.
//
import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
