
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import RxSwift
import EasyBaseAudio

class AllFilesVM {
    
    let sourceURLs: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    
    private let disposeBag = DisposeBag()
    init() {
        
    }
    
    func getURLs() {
        let audio = AudioManage.shared.getItemsFolder(folder: ConstantApp.FolderName.folderAudio.rawValue).filter { $0.getDuration() > 0 }
        let video = AudioManage.shared.getItemsFolder(folder: ConstantApp.FolderName.folderVideo.rawValue).filter { $0.getDuration() > 0 }
        sourceURLs.accept(audio + video)
    }

}
