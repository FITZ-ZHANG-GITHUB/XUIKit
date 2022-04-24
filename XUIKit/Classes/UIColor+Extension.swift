//
//  UIColor+Extension.swift
//  XUIKit
//
//  Created by FITZ on 2022/4/24.
//

import UIKit

extension UIColor: XUIKitCompatible {}

private extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}

private extension UIColor {
    private convenience init?(hex3: Int64, alpha: Float) {
        self.init(red: CGFloat(((hex3 & 0xF00) >> 8).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex3 & 0x0F0) >> 4).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex3 & 0x00F) >> 0).duplicate4bits()) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int64, alpha: Float?) {
        self.init(red: CGFloat(((hex4 & 0xF000) >> 12).duplicate4bits()) / 255.0,
                  green: CGFloat(((hex4 & 0x0F00) >> 8).duplicate4bits()) / 255.0,
                  blue: CGFloat(((hex4 & 0x00F0) >> 4).duplicate4bits()) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat(((hex4 & 0x000F) >> 0).duplicate4bits()) / 255.0)
    }

    private convenience init?(hex6: Int64, alpha: Float) {
        self.init(red: CGFloat((hex6 & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex6 & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((hex6 & 0x0000FF) >> 0) / 255.0, alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int64, alpha: Float?) {
        self.init(red: CGFloat((hex8 & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((hex8 & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((hex8 & 0x0000FF00) >> 8) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat((hex8 & 0x000000FF) >> 0) / 255.0)
    }

    /**
     Create non-autoreleased color with in the given hex string and alpha.

     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    convenience init?(hexString: String, alpha: Float? = nil) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int64(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha ?? 1.0)
        case 4:
            self.init(hex4: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha ?? 1.0)
        case 8:
            self.init(hex8: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }

    /**
     Create non-autoreleased color with in the given hex value and alpha

     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    convenience init?(hex: Int, alpha: Float = 1.0) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: Int64(hex), alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}

public extension XUIKitWrapper where Base: UIColor {
    /// 通过HEX值生成UIColor
    static func color(hexString: String, alpha: Float? = nil) -> UIColor {
        return UIColor(hexString: hexString, alpha: alpha) ?? .clear
    }
    
    /// 生成渐变色
    /// - Parameters:
    ///   - colors: 渐变色颜色数组
    ///   - width: 宽度
    ///   - height: 高度
    ///   - axis: 坐标轴
    /// - Returns: 渐变色
    static func gradient(colors: [UIColor], width: CGFloat, height: CGFloat, axis: NSLayoutConstraint.Axis = .vertical) -> UIColor? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor }
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil) else {
            return nil
        }

        switch axis {
        case .vertical:
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 0, y: height), options: .drawsBeforeStartLocation)
        case .horizontal:
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: width, y: 0), options: .drawsBeforeStartLocation)
        @unknown default:
            fatalError()
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        return UIColor(patternImage: image)
    }
}
