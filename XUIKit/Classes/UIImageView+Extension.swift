//
//  UIImageView+Extension.swift
//  XUIKit
//
//  Created by FITZ on 2022/4/24.
//

import UIKit
import QuartzCore

private let rotateAnimationKey = "RotateAnimationKey"
public extension XUIKitWrapper where Base: UIImageView {
    /// 开始动画
    func startRotatianAnimation(duration: CFTimeInterval) {
        if base.layer.animation(forKey: rotateAnimationKey) != nil {
            if base.layer.speed == 1 { return }
            base.layer.speed = 1
            base.layer.beginTime = 0
            let pauseTime = base.layer.timeOffset
            base.layer.timeOffset = 0
            base.layer.beginTime = base.layer.convertTime(CACurrentMediaTime(), to: nil) - pauseTime
        } else {
            addRotatianAnimation(duration: duration)
        }
    }

    /// 复位动画
    func resetRotatianAnimation(duration: CFTimeInterval) {
        if base.layer.animation(forKey: rotateAnimationKey) != nil {
            base.layer.removeAnimation(forKey: rotateAnimationKey)
            base.layer.speed = 1
            base.layer.timeOffset = 0
        }
    }

    /// 添加动画
    func addRotatianAnimation(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(floatLiteral: Double.pi * 2.0)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.autoreverses = false
        animation.isCumulative = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.repeatCount = Float.greatestFiniteMagnitude
        if base.layer.speed == 0 {
            base.layer.speed = 1
            base.layer.timeOffset = 0
        }
        base.layer.add(animation, forKey: rotateAnimationKey)
    }

    /// 停止动画
    func stopRotatianAnimation() {
        if base.layer.speed == 0 { return }
        let pausedTime = base.layer.convertTime(CACurrentMediaTime(), from: nil)
        base.layer.speed = 0
        base.layer.timeOffset = pausedTime
    }
    
}
