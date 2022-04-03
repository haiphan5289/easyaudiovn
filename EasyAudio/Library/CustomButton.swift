//
//  CustomButton.swift
//  CanCook
//
//  Created by paxcreation on 2/1/21.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

//    override var isHighlighted: Bool {
//        didSet {
//            backgroundColor = isHighlighted ? BUTTON_COLOR : COLOR_APP
//        }
//    }
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
//    @IBInspectable override var borderColor: UIColor? {
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//        set {
//            guard let color = newValue else {
//                layer.borderColor = nil
//                return
//            }
//            // Fix React-Native conflict issue
//            guard String(describing: type(of: color)) != "__NSCFType" else { return }
//            layer.borderColor = color.cgColor
//        }
//    }
//
//    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
//    @IBInspectable override var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
//    @IBInspectable override var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.masksToBounds = true
//            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
//        }
//    }
}
