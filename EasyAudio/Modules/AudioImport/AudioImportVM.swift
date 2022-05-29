
//
//  ___HEADERFILE___
//
import Foundation
import RxCocoa
import RxSwift
import EasyBaseAudio

class AudioImportVM {
    @VariableReplay var urls: [URL] = []
    private let disposeBag = DisposeBag()
    init(folderName: String) {
        self.getUrls(folderName: folderName)
    }
    
    func getUrls(folderName: String) {
        self.urls = AudioManage.shared.getItemsFolder(folder: folderName).filter { $0.getDuration() > 0 }
    }
}
