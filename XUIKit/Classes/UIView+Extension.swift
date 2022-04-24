//
//  UIView+Extension.swift
//  XUIKit
//
//  Created by FITZ on 2022/4/24.
//

import UIKit

// MARK: - CALayer
extension CALayer: XUIKitCompatible {}
public extension XUIKitWrapper where Base: CALayer {
    // 设置阴影
    func setLayerShadow(color: UIColor = UIColor.lightGray, radius: CGFloat = 1.0, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 1.0) {
        base.shadowColor = color.cgColor
        base.shadowOffset = offset
        base.shadowRadius = radius
        base.shadowOpacity = opacity
    }
}

// MARK: - UIView
extension UIView: XUIKitCompatible {}
private let kRotationAnimationKey = "rotationanimationkey"
public extension XUIKitWrapper where Base: UIView {
    /// view所在的VC
    var managerController: UIViewController? {
        var responder: UIResponder? = base
        while responder != nil, responder?.isKind(of: UIViewController.self) == false {
            responder = responder!.next
        }
        if responder == nil { return nil }
        if responder?.isKind(of: UIViewController.self) == true {
            return responder as? UIViewController
        }
        return nil
    }
    
    /// 360旋转View
    /// - Parameters:
    ///   - duration: 执行时间
    ///   - repeatCount: 执行次数，默认为循环执行
    func startRotating(duration: Double = 1, repeatCount: Float = Float.infinity) {
        if base.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = repeatCount
            base.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }

    /// 停止旋转
    func stopRotating() {
        if base.layer.animation(forKey: kRotationAnimationKey) != nil {
            base.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    
    /// 圆角
    @discardableResult func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        base.layer.mask = mask
        return mask
    }
    
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        base.layer.masksToBounds = true
        base.layer.cornerRadius = diameter / 2
        base.layer.borderWidth = borderWidth
        base.layer.borderColor = borderColor.cgColor
    }

    /// 边框
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = base.bounds
        base.layer.addSublayer(borderLayer)
    }
    
}

