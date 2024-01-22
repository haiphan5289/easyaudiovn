
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import RxSwift
import EasyBaseAudio

class AudioVM {
    
    let sourceURLs: BehaviorRelay<[URL]> = BehaviorRelay.init(value: [])
    
    private let disposeBag = DisposeBag()
    init() {
        
    }
    
    func getURLs() {
        sourceURLs.accept(AudioManage.shared.getItemsFolder(folder: ConstantApp.FolderName.folderAudio.rawValue).filter { $0.getDuration() > 0 })
    }
}
