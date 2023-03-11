
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import RxSwift
import Photos

class VideoFromPhotosVM {
    
    let phAssestTrigger: BehaviorRelay<[PHAsset]> = BehaviorRelay.init(value: [])
    let activity: ActivityIndicator = ActivityIndicator()
    
    private let disposeBag = DisposeBag()
    init() {
        
    }
    
    func fetchVideo() {
        ManageApp.shared.checkPhotoLibraryPermission()
            .trackActivity(activity)
            .bind(to: phAssestTrigger)
            .disposed(by: disposeBag)
    }
}
