//
//  UIImage+Extension.swift
//  XUIKit
//
//  Created by FITZ on 2022/4/24.
//

import UIKit

extension UIImage: XUIKitCompatible {}
public extension XUIKitWrapper where Base: UIImage {
    /// 修复图片旋转
    func fixOrientation() -> UIImage {
        if base.imageOrientation == .up {
            return base
        }
         
        var transform = CGAffineTransform.identity
         
        switch base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: base.size.height)
            transform = transform.rotated(by: .pi)
             
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
             
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: base.size.height)
            transform = transform.rotated(by: -.pi / 2)
             
        default:
            break
        }
         
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
             
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: base.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
             
        default:
            break
        }
         
        let ctx = CGContext(data: nil,
                            width: Int(base.size.width),
                            height: Int(base.size.height),
                            bitsPerComponent: base.cgImage!.bitsPerComponent,
                            bytesPerRow: 0,
                            space: base.cgImage!.colorSpace!,
                            bitmapInfo: base.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
         
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.height), height: CGFloat(base.size.width)))
             
        default:
            ctx?.draw(base.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(base.size.width), height: CGFloat(base.size.height)))
        }
         
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
         
        return img
    }
    
    /// 图片上色
    func imageChangeColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        UIRectFill(bounds)
        base.draw(in: bounds, blendMode: .overlay, alpha: 1.0)
        base.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 压缩
    func compress(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
