
//
//  
//  CheckUIVC.swift
//  EasyAudio
//
//  Created by haiphan on 30/05/2022.
//
//
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class CheckUIVC: UIViewController {
    
    // Add here outlets
  @IBOutlet weak var stackView: UIStackView!
  
    // Add here your view model
    private var viewModel: CheckUIVM = CheckUIVM()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension CheckUIVC {
    
    private func setupUI() {
        // Add here the setup for the UI
      let v: CTDiscountNewPreniumView = CTDiscountNewPreniumView(frame: .zero)
      self.stackView.insertArrangedSubview(v, at: 1)
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}

class CTDiscountNewPreniumView: UIView {
  private var discountLB: UILabel = UILabel(frame: .zero)
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension CTDiscountNewPreniumView {
  func setupUI() {
    self.backgroundColor = .red
    self.discountLB.textColor = .black
    self.discountLB.textAlignment = .center
    self.discountLB.text = "-100%"
    self.addSubview(self.discountLB)
    self.discountLB.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(8)
    }
  }
}
