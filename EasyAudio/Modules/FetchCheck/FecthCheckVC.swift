
//
//  
//  FecthCheckVC.swift
//  EasyAudio
//
//  Created by haiphan on 25/02/2024.
//
//
import UIKit
import RxCocoa
import RxSwift
import Photos

class FecthCheckVC: UIViewController, SetupBaseCollection {
    
    // Add here outlets
    @IBOutlet weak var collectionView: UICollectionView!
    private var sources: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    var allPhotos : PHFetchResult<PHAsset>? = nil
    
    // Add here your view model
    private var viewModel: FecthCheckVM = FecthCheckVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
extension FecthCheckVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        setupCollectionView(collectionView: collectionView,
                            delegate: self,
                            name: FetchCheckCell.self)
        collectionView.dataSource = self
        getPhotos()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
//        sources
//            .bind(to: self.collectionView.rx.items(cellIdentifier: FetchCheckCell.identifier, cellType: FetchCheckCell.self)) { row, data, cell in
//                cell.backgroundColor = row % 2 == 0 ? .red : .blue
//            }.disposed(by: disposeBag)
    }
    
    fileprivate func getPhotos() {
        
        /// Load Photos
           PHPhotoLibrary.requestAuthorization { (status) in
               switch status {
               case .authorized:
                   print("Good to proceed")
                   let fetchOptions = PHFetchOptions()
                   self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                   DispatchQueue.main.async {
                       self.collectionView.reloadData()
                   }
               case .denied, .restricted:
                   print("Not allowed")
               case .notDetermined:
                   print("Not determined yet")
               case .limited: break
               @unknown default: break
               }
           }
        
//        var images = [Int]()
//        let manager = PHImageManager.default()
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = false
//        requestOptions.deliveryMode = .highQualityFormat
//        // .highQualityFormat will return better quality photos
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//        if results.count > 0 {
//            for i in 0..<results.count {
//                let asset = results.object(at: i)
//                let size = CGSize(width: 700, height: 700)
//                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
//                    if let image = image {
//                        images.append(i)
//                        self.sources.accept(images)
//                    } else {
//                        print("error asset to image")
//                    }
//                }
//            }
//        } else {
//            print("no photos to display")
//        }

    }
}
extension FecthCheckVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: FetchCheckCell.identifier,
                                                           for: indexPath) as! FetchCheckCell
        cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .blue
            return cell
    }
    
    
}
extension FecthCheckVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
