////
////  UIImage+Extensions.swift
////  SenViet
////
////  Created by Dong Nguyen on 8/10/17.
////  Copyright © 2017 com.senviet. All rights reserved.
////
//
//import Foundation
//import UIKit
////import AlamofireImage
////import Alamofire
//
//extension UIImage {
//    class func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        color.setFill()
//        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
//    func fixOrientation() -> UIImage {
//        if self.imageOrientation == UIImage.Orientation.up {
//            return self
//        }
//
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//
//        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
//        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        return normalizedImage;
//    }
//
//    func resizeImage(_ targetSize: CGSize) -> UIImage {
//        let size = self.size
//        if size.width < targetSize.width || size.height < targetSize.height {
//            return self
//        }
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//
//    convenience init(view: UIView) {
//
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//
//    func tint(with color: UIColor) -> UIImage {
//        var image = withRenderingMode(.alwaysTemplate)
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        color.set()
//
//        image.draw(in: CGRect(origin: .zero, size: size))
//        image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return image
//    }
//
//
//    /// Kudos to Trevor Harmon and his UIImage+Resize category from
//    // which this code is heavily inspired.
//    func resetOrientation() -> UIImage {
//
//        // Image has no orientation, so keep the same
//        if imageOrientation == .up {
//            return self
//        }
//
//        // Process the transform corresponding to the current orientation
//        var transform = CGAffineTransform.identity
//        switch imageOrientation {
//        case .down, .downMirrored:           // EXIF = 3, 4
//            transform = transform.translatedBy(x: size.width, y: size.height)
//            transform = transform.rotated(by: CGFloat(Double.pi))
//
//        case .left, .leftMirrored:           // EXIF = 6, 5
//            transform = transform.translatedBy(x: size.width, y: 0)
//            transform = transform.rotated(by: CGFloat(Double.pi / 2))
//
//        case .right, .rightMirrored:          // EXIF = 8, 7
//            transform = transform.translatedBy(x: 0, y: size.height)
//            transform = transform.rotated(by: -CGFloat((Double.pi / 2)))
//        default:
//            ()
//        }
//
//        switch imageOrientation {
//        case .upMirrored, .downMirrored:     // EXIF = 2, 4
//            transform = transform.translatedBy(x: size.width, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//
//        case .leftMirrored, .rightMirrored:   //EXIF = 5, 7
//            transform = transform.translatedBy(x: size.height, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//        default:
//            ()
//        }
//
//        // Draw a new image with the calculated transform
//        let context = CGContext(data: nil,
//                                width: Int(size.width),
//                                height: Int(size.height),
//                                bitsPerComponent: cgImage!.bitsPerComponent,
//                                bytesPerRow: 0,
//                                space: cgImage!.colorSpace!,
//                                bitmapInfo: cgImage!.bitmapInfo.rawValue)
//        context?.concatenate(transform)
//        switch imageOrientation {
//        case .left, .leftMirrored, .right, .rightMirrored:
//            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
//        default:
//            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        }
//
//        if let newImageRef =  context?.makeImage() {
//            let newImage = UIImage(cgImage: newImageRef)
//            return newImage
//        }
//
//        // In case things go wrong, still return self.
//        return self
//    }
//
//    // Reduce image size further if needed targetImageSize is capped.
//
//    fileprivate func cappedSize(for size: CGSize, cappedAt: CGFloat) -> CGSize {
//        var cappedWidth: CGFloat = 0
//        var cappedHeight: CGFloat = 0
//        if size.width > size.height {
//            // Landscape
//            let heightRatio = size.height / size.width
//            cappedWidth = min(size.width, cappedAt)
//            cappedHeight = cappedWidth * heightRatio
//        } else if size.height > size.width {
//            // Portrait
//            let widthRatio = size.width / size.height
//            cappedHeight = min(size.height, cappedAt)
//            cappedWidth = cappedHeight * widthRatio
//        } else {
//            // Squared
//            cappedWidth = min(size.width, cappedAt)
//            cappedHeight = min(size.height, cappedAt)
//        }
//        return CGSize(width: cappedWidth, height: cappedHeight)
//    }
//
//    func toCIImage() -> CIImage? {
//        return self.ciImage ?? CIImage(cgImage: self.cgImage!)
//    }
//
//}
//extension UIImageView {
//
//    func afImageURL(_ url : String?, placeHolder : UIImage?,filter:ImageFilter? = nil , _ completeHanlder : ((_ image: UIImage? )->())? = nil) {
//        self.image = placeHolder
//        guard let imageURLString =  url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            self.image = placeHolder
//            return
//        }
//
//
//        if let url = URL.init(string: leftTrim(imageURLString, ["/"])) {
//            self.af.setImage(withURL: url, placeholderImage: placeHolder, filter: filter) { (response) in
//                guard let image = response.value else{
//                    return
//                }
//                if completeHanlder != nil {
//                    completeHanlder!(image)
//
//                }
//            }
//        }
//    }
//
//    func leftTrim(_ str: String, _ chars: Set<Character>) -> String {
//        if let index = str.firstIndex(where: {!chars.contains($0)}) {
//            let url = String(str[index..<str.endIndex])
//            if !(url.contains("http") || url.contains("https")) {
//                return "http://\(url)"
//            }
//            return url
//        } else {
//            return ""
//        }
//    }
//}
//

