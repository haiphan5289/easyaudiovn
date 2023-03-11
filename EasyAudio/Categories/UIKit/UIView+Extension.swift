//
//  AppDelegate.swift
//  AplicationiOS
//
//  Created by TVT25 on 10/25/16.
//  Copyright © 2016 TVT25. All rights reserved.
//

import UIKit
import EasyBaseCodes

extension UIView {
    
    func dropShadow(radius : CGFloat = 1, borderColor : UIColor, borderWidth: CGFloat = 0.5, shadowColor: UIColor, opacity: Float = 0.5, offSet: CGSize, shadowRadius: CGFloat = 1) {
        // corner radius
        self.layer.cornerRadius = radius
        // border
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        // shadow
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
    }
    
    func dropShadow(radius : CGFloat = 1, borderColor : UIColor, borderWidth: CGFloat = 0.5, shadowColor: UIColor, opacity: Float = 0.5, offSet: CGSize, shadowRadius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        // corner radius
        self.layer.cornerRadius = radius
        
        // border
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        // shadow
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
    }
    
    func borderWithGradient(color1 : UIColor, color2 : UIColor, width : CGFloat = 1) {
        let height = self.bounds.size.height/2
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.cornerRadius = height
        
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 2.5, dy: 2.5), cornerRadius: height).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.cornerRadius = height
        gradient.mask = shape
        
        self.clipsToBounds = true
        self.layer.cornerRadius = height
        self.layer.addSublayer(gradient)
    }
    
    //    func addBottomLine() {
    //        let lineView = UIView.init()
    //        lineView.backgroundColor  = UIColor.init(hex: "EFEFF4")
    //        self.addSubview(lineView)
    //        lineView.snp.makeConstraints { (make) in
    //            make.leading.trailing.bottom.equalToSuperview()
    //            make.height.equalTo(0.5)
    //        }
    //    }
    
    
    
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}


extension UIView {
    public func addShadow(ofColor color: UIColor? = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat? = 3, offset: CGSize? = .zero, opacity: Float? = 0.5) {
        layer.shadowColor = color?.cgColor ?? UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0).cgColor
        layer.shadowOffset = offset ?? .zero
        layer.shadowRadius = radius ?? 3
        layer.shadowOpacity = opacity ?? 0.5
        layer.masksToBounds = false
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

//      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//      layer.shouldRasterize = true
//      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIScrollView {
    func scrollToBottom(_ animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}


extension UIView {
    
    func addBlur(style: UIBlurEffect.Style = .extraLight) {
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        
        blurBackground.frame = self.bounds
        self.addSubview(blurBackground)
        
//        blurBackground.translatesAutoresizingMaskIntoConstraints = false
//        blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        self.addSubview(blurBackground)
    }
}

extension UIView {
    func gradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func gradient(colours: [UIColor], start: CGPoint = CGPoint(x: 0.5, y: 1.0), end: CGPoint =  CGPoint(x: 0.5, y: 0.0) ) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.withAlphaComponent(1.0).cgColor }
        gradient.startPoint = start
        gradient.endPoint = end
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class GradientButton: UIButton {
    var colors: [UIColor] = []
    var start: CGPoint = CGPoint(x: 0, y: 1.0)
    var end: CGPoint =  CGPoint(x: 0.5, y: 1.0)
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initDefault()
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors.map { $0.withAlphaComponent(1.0).cgColor }
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        gradientLayer.name = self.propertiesToSend
    }
    
    private func initDefault() {
        colors = [#colorLiteral(red: 0.9809789062, green: 0.8029752374, blue: 0.5312047601, alpha: 1),#colorLiteral(red: 0.9632317424, green: 0.6677338481, blue: 0.4912498593, alpha: 1),#colorLiteral(red: 0.9375460744, green: 0.4920235276, blue: 0.4438247085, alpha: 1)]
        start = CGPoint(x: 0, y: 1.0)
        end = CGPoint(x: 0.5, y: 1.0)
        
    }
    
    func showGradient(show : Bool) {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        if show {
            gradientLayer.colors = colors.map { $0.withAlphaComponent(1.0).cgColor }
        } else {
            gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        }
    }
}

class GradientView: UIView {
    var colors: [UIColor] = []
    var start: CGPoint = CGPoint(x: 0, y: 1.0)
    var end: CGPoint =  CGPoint(x: 0.5, y: 1.0)
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initDefault()
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors.map { $0.withAlphaComponent(1.0).cgColor }
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
    }
    
    private func initDefault() {
        colors = [#colorLiteral(red: 0.9809789062, green: 0.8029752374, blue: 0.5312047601, alpha: 1),#colorLiteral(red: 0.9632317424, green: 0.6677338481, blue: 0.4912498593, alpha: 1),#colorLiteral(red: 0.9375460744, green: 0.4920235276, blue: 0.4438247085, alpha: 1)]
        start = CGPoint(x: 0, y: 1.0)
        end = CGPoint(x: 0.5, y: 1.0)
        
    }
    
    func showGradient(show : Bool) {
        if let gradientLayer = self.layer as? CAGradientLayer {
            gradientLayer.isHidden = !show
        }
    }
}


import ObjectiveC
private var key: Void? = nil // the address of key is a unique id.

extension UIView {
    var propertiesToSend: String {
        get { return objc_getAssociatedObject(self, &key) as? String ?? "" }
        set { objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

extension UIView {
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   color: UIColor,
                   offSet: CGSize,
                   opacity: Float,
                   shadowRadius: CGFloat) {

        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

