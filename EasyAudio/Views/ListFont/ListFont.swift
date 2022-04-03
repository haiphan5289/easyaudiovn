//
//  ListFont.swift
//  Note
//
//  Created by haiphan on 04/10/2021.
//

import UIKit
import RxCocoa
import RxSwift

//protocol ListFontDelegate {
//    func dismissListFont()
//    func done(font: UIFont)
//    func search()
//    func updateFontStyle(font: UIFont)
//}
//
//enum StatusList {
//    case zero, other
//
//    static func getStatus(count: Int) -> Self {
//        if count == 0 {
//            return zero
//        }
//
//        return other
//    }
//}

class ListFont: UIView {
    
//    struct Constant {
//        static let characterMiddle: String = "-"
//        static let firstName: String = "Normal"
//        static let defaultSize: CGFloat = 14
//        static let minimumSize: CGFloat = 7
//        static let maximumSize: CGFloat = 28
//    }
//
//    enum FontType: Int, CaseIterable {
//        case listFont
//        case listSize
//
//        func getListFont() -> [String] {
//            return UIFont.familyNames
//        }
//
//        func getListSize(forFamilyName: String) -> [String] {
//            return UIFont.fontNames(forFamilyName: forFamilyName)
//        }
//
//        func getIndexFontDefault() -> Int? {
//            let fontName = ConstantCommon.shared.fontDefault.familyName
//            if let index = UIFont.familyNames.firstIndex(where: { $0 == fontName }) {
//                return index
//            }
//            return nil
//        }
//
//
//    }
//
//    enum Action: Int, CaseIterable {
//        case close, done, search, minus, plus
//    }
//
//    var delegate: ListFontDelegate?
    
    @IBOutlet weak var listFontTableView: UITableView!
    @IBOutlet weak var listSizeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var bts: [UIButton]!
    @IBOutlet weak var lbSize: UILabel!
    
//    private var listSize: BehaviorRelay<[String]> = BehaviorRelay.init(value: [])
//    private var listFont: BehaviorRelay<[String]> = BehaviorRelay.init(value: [])
//    private var selectIndexFont: Int = FontType.listFont.getIndexFontDefault() ?? 0
//    private var selectIndexSize: Int = 0
//    private var selectIndexFontPrevious: Int = 0
//    private var selectIndexSizePrevious: Int = 0
//    private var currentFont: UIFont?
//    private var sizeFont = ConstantCommon.shared.sizeDefault
//    private var fontFamilyNames: String = SettingDefaultFont.DEFAULT_NAME_FONT
//    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
//        setupUI()
//        setupRX()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func removeFromSuperview() {
        superview?.removeFromSuperview()
    }
    
}
extension ListFont {
    
//    private func setupUI() {
//        
//        self.layer.cornerRadius = ConstantCommon.shared.radiusViewDialog
//        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        
//        listFontTableView.delegate = self
//        listSizeTableView.delegate = self
//        listFontTableView.register(FontCell.nib, forCellReuseIdentifier: FontCell.identifier)
//        listSizeTableView.register(FontSize.nib, forCellReuseIdentifier: FontSize.identifier)
//        self.listSize.accept(FontType.listSize.getListSize(forFamilyName: self.fontFamilyNames))
//        self.listFont.accept(FontType.listFont.getListFont())
//        listFontTableView.scrollToIndex(index: self.selectIndexFont)
//        
//        
//        self.lbSize.text = "\(self.sizeFont)"
//        
//        self.selectIndexFontPrevious = self.selectIndexFont
//        self.selectIndexSizePrevious = self.selectIndexSize
//    }
//    
//    private func setupRX() {
//        self.listFont.asObservable()
//            .bind(to: listFontTableView.rx.items(cellIdentifier: FontCell.identifier, cellType: FontCell.self)) {(row, element, cell) in
//                cell.lbName.text = element
//                
//                if row == self.selectIndexFont {
//                    cell.img.image = Asset.icCheckbox.image
//                    cell.img.tintColor = Asset.colorApp.color
//                    cell.lbName.textColor = Asset.colorApp.color
//                } else {
//                    cell.img.image = Asset.icUncheck.image
//                    cell.img.tintColor = Asset.disableHome.color
//                    cell.lbName.textColor = .white
//                }
//                
//            }.disposed(by: disposeBag)
//        
//        self.listSize.asObservable()
//            .bind(to: listSizeTableView.rx.items(cellIdentifier: FontSize.identifier, cellType: FontSize.self)) {(row, element, cell) in
//                if row == 0 {
//                    cell.lbName.text = Constant.firstName
//                } else {
//                    if let range = element.searchLocation(searchText: Constant.characterMiddle), let cutString = element.cutString(range: range) {
//                        cell.lbName.text = cutString
//                    }
//                }
//                
//                if row == self.selectIndexSize {
//                    cell.img.image = Asset.icCheckbox.image
//                    cell.img.tintColor = Asset.colorApp.color
//                    cell.lbName.textColor = Asset.colorApp.color
//                } else {
//                    cell.img.image = Asset.icUncheck.image
//                    cell.img.tintColor = Asset.disableHome.color
//                    cell.lbName.textColor = .white
//                }
//            }.disposed(by: disposeBag)
//        
//        self.listFontTableView.rx.itemSelected.bind { [weak self] idx in
//            guard let wSelf = self else { return }
//            if wSelf.selectIndexFont != idx.row {
//                wSelf.selectIndexFont = idx.row
//                wSelf.selectIndexSize = 0
//                let name = FontType.listFont.getListFont()[idx.row]
//                wSelf.updateListSize(name: name)
//                wSelf.listFontTableView.reloadData()
//                wSelf.selectFont()
//            }
//        }.disposed(by: disposeBag)
//        
//        self.listSizeTableView.rx.itemSelected.bind { [weak self] idx in
//            guard let wSelf = self else { return }
//            wSelf.selectIndexSize = idx.row
//            wSelf.listSizeTableView.reloadData()
//            wSelf.selectFont()
//        }.disposed(by: disposeBag)
//        
//        self.searchBar.rx.text.orEmpty.asObservable().bind { [weak self] text in
//            guard let wSelf = self else { return }
//            switch StatusList.getStatus(count: text.count) {
//            case .zero:
//                wSelf.listFont.accept(FontType.listFont.getListFont())
//            case .other:
//                let list = FontType.listFont.getListFont().filter { $0.uppercased().contains(text.uppercased()) }
//                wSelf.listFont.accept(list)
//            }
//        }.disposed(by: disposeBag)
//        
//        Action.allCases.forEach { [weak self] type in
//            guard let wSelf = self else { return }
//            let bt = wSelf.bts[type.rawValue]
//            
//            bt.rx.tap.bind { [weak self] _ in
//                guard let wSelf = self else { return }
//                switch type {
//                case .close:
//                    wSelf.delegate?.dismissListFont()
//                    wSelf.selectIndexFont = wSelf.selectIndexFontPrevious
//                    wSelf.selectIndexSize = wSelf.selectIndexSizePrevious
//                case .done:
//                    if let f = wSelf.currentFont {
//                        wSelf.delegate?.done(font: f)
//                        wSelf.selectIndexFontPrevious = wSelf.selectIndexFont
//                        wSelf.selectIndexSizePrevious = wSelf.selectIndexSize
//                    }
//                case .search: wSelf.delegate?.search()
//                case .minus:
//                    wSelf.sizeFont -= 1
//                    if wSelf.sizeFont <= Constant.minimumSize {
//                        wSelf.sizeFont = Constant.minimumSize
//                    }
//                    wSelf.selectFont()
//                case .plus:
//                    wSelf.sizeFont += 1
//                    if wSelf.sizeFont >= Constant.maximumSize {
//                        wSelf.sizeFont = Constant.maximumSize
//                    }
//                    wSelf.selectFont()
//                }
//                wSelf.lbSize.text = "\(wSelf.sizeFont)"
//            }.disposed(by: disposeBag)
//        }
//        
//    }
//    
//    func selectFont() {
//        let font = FontType.listFont.getListFont()[self.selectIndexFont]
//        if let index = FontType.listSize.getListSize(forFamilyName: font).hasIndex(index: self.selectIndexSize) {
//            let style = FontType.listSize.getListSize(forFamilyName: font)[index]
//            self.currentFont = UIFont(name: style, size: self.sizeFont)
//            self.delegate?.updateFontStyle(font: self.currentFont ?? .systemFont(ofSize: self.sizeFont))
//        }
//    }
//    
//    func scrollWhenOpen() {
//        self.listFontTableView.scrollToIndex(index: self.selectIndexFont)
//        let name = FontType.listFont.getListFont()[self.selectIndexFont]
//        self.updateListSize(name: name)
//    }
//    
//    func scrollToIndex(index: Int) {
//        self.selectIndexFont = index
//        self.listFontTableView.scrollToIndex(index: index)
//        self.listFontTableView.reloadData()
//        
//        self.selectIndexSize = 0
//        let name = FontType.listFont.getListFont()[index]
//        self.updateListSize(name: name)
//        self.selectFont()
//    }
//    
//    func getSelectIndexFont() -> Int {
//        return self.selectIndexFont
//    }
//    
//    private func updateListSize(name: String) {
//        self.fontFamilyNames = name
//        self.listSize.accept(FontType.listSize.getListSize(forFamilyName: self.fontFamilyNames))
//    }
//    
//    func addViewToParent(view: UIView) {
//        view.addSubview(self)
//        self.snp.makeConstraints { make in
//            make.bottom.left.right.equalToSuperview()
//            make.height.equalTo(BaseNavigationHeader.Constant.heightViewListFont)
//        }
//    }
//    
//    func hide() {
//        self.isHidden = true
//    }
//    
//    func showView() {
//        self.isHidden = false
//    }
}
extension ListFont: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
}
