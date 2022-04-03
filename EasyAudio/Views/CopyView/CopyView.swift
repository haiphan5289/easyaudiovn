//
//  CopyView.swift
//  ManageFiles
//
//  Created by haiphan on 15/01/2022.
//

import UIKit
import RxSwift

class CopyView: UIView {
    
    struct Constant {
        static let distanceToLeft: Int = 25
    }
    
    let url: URL
    let numberOffoldes: Int
    
    var actionTap: ((Bool) -> Void)?
    private let stackParent: UIStackView = UIStackView(arrangedSubviews: [],
                                         axis: .vertical,
                                         spacing: 0,
                                         alignment: .fill,
                                         distribution: .fill)
    private let stackExplain: UIStackView = UIStackView(arrangedSubviews: [],
                                         axis: .vertical,
                                         spacing: 0,
                                         alignment: .fill,
                                         distribution: .fill)
    private let btPress: UIButton = UIButton(frame: .zero)
    private let checkImg: UIImageView = UIImageView(image: Asset.imgCheck.image)
    private let imgArrow: UIImageView = UIImageView(image: Asset.imgArrowRight.image)
    private let explainView: UIView = UIView(frame: .zero)
    private let disposeBag = DisposeBag()
    
    required init(url: URL, numberOffoldes: Int) {
        self.url = url
        self.numberOffoldes = numberOffoldes
        super.init(frame: .zero)
        self.setupUI()
        self.setupRX()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CopyView {
    
    private func setupUI() {
        self.checkImg.isHidden = true
        self.setupView(url: self.url)
    }
    
    private func setupRX() {
        self.btPress.rx.tap.bind { [weak self] _ in
            guard let wSelf = self else { return }
            if wSelf.btPress.isSelected {
                wSelf.btPress.isSelected = false
                wSelf.hideCheckImg()
                wSelf.actionTap?(false)
            } else {
                wSelf.btPress.isSelected = true
                wSelf.showCheckImg()
                wSelf.actionTap?(true)
            }
            
        }.disposed(by: self.disposeBag)
    }
    
    func addViewToStackExplain(copyView: CopyView) {
        self.stackExplain.addArrangedSubview(copyView)
    }
    
    func hideCheckImg() {
        self.checkImg.isHidden = true
        self.imgArrow.image = Asset.imgArrowRight.image
        self.btPress.isSelected = false
    }
    
    func showCheckImg() {
        self.checkImg.isHidden = false
        self.imgArrow.image = Asset.imgDrop.image
        self.btPress.isSelected = true
    }
    
    func removeSubviewStackView() {
        self.stackExplain.subviews.forEach { v in
            v.removeFromSuperview()
        }
    }
    
    func showExplainView(isHide: Bool) {
        self.explainView.isHidden = isHide
    }
    
    private func setupView(url: URL) {
        let v: UIView = UIView(frame: .zero)
        v.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [],
                                                 axis: .horizontal,
                                                 spacing: 12,
                                                 alignment: .center,
                                                 distribution: .fill)
        self.imgArrow.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
        
        let img: UIImageView = UIImageView(image: self.uploadImage(url: url))
        img.snp.makeConstraints { make in
            make.height.width.equalTo(28)
        }
        
        let lbName: UILabel = UILabel(frame: .zero)
        lbName.font = UIFont.mySystemFont(ofSize: 17)
        lbName.textColor = Asset.black.color
        lbName.text = "\(url.lastPathComponent)"
        lbName.textAlignment = .left
        
        self.checkImg.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
                
        stackView.addArrangedSubview(imgArrow)
        stackView.addArrangedSubview(img)
        stackView.addArrangedSubview(lbName)
        stackView.addArrangedSubview(self.checkImg)
        v.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(8)
        }
        
        let lineView: UIView = UIView(frame: .zero)
        lineView.backgroundColor = Asset.lineView.color
        v.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(lbName)
        }
        
        v.addSubview(self.btPress)
        self.btPress.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackParent.addArrangedSubview(v)
        
        self.explainView.isHidden = true
        self.explainView.addSubview(self.stackExplain)
        self.stackExplain.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.stackParent.addArrangedSubview(self.explainView)
        self.explainView.snp.makeConstraints { make in
        }
        
        self.addSubview(self.stackParent)
        self.stackParent.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.left.equalToSuperview().inset(self.numberOffoldes * Constant.distanceToLeft)
        }
    }
    
    private func uploadImage(url: URL) -> UIImage {
        if let index = ManageApp.shared.folders.firstIndex(where: { $0.url.getNamePath().uppercased().contains(url.getNamePath().uppercased())}),
           let name = ManageApp.shared.folders[index].imgName {
            return UIImage(named: name) ?? Asset.icOtherFolder.image
        }
        
        return Asset.icOtherFolder.image
    }
}
