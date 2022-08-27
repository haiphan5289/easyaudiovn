
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import EasyBaseAudio
import RxSwift

class VideoVM {
    
    let sourceURLs: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    private let disposeBag = DisposeBag()
    init() {
        
    }
    
    func getURLs() {
        sourceURLs.accept(AudioManage.shared.getItemsFolder(folder: ConstantApp.FolderName.folderVideo.rawValue).filter { $0.getDuration() > 0 })
    }
    
}
