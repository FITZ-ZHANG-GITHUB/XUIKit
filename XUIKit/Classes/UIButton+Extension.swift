//
//  UIButton+Extension.swift
//  XUIKit
//
//  Created by FITZ on 2022/4/24.
//

import UIKit

public extension XUIKitWrapper where Base: UIButton {
    /// 调整文字和图片的距离
    /// parameter spacing: 距离
    func centerTextAndImageWithSpacing(_ spacing: CGFloat) {
        let insetAmount = spacing / 2
        base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        base.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }

    
    /// 设置按钮图片居右边显示
    func imageOnTheRight() {
        base.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        base.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        base.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }

    /// 设置按钮图片和文字上下间距
    /// - Parameter spacing: 上下间距
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = base.imageView?.image?.size,
              let text = base.titleLabel?.text,
              let font = base.titleLabel?.font
        else { return }

        base.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageSize.width,
            bottom: -(imageSize.height + spacing),
            right: 0.0
        )

        let titleSize = text.size(withAttributes: [.font: font])
        base.imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0.0,
            bottom: 0.0,
            right: -titleSize.width
        )

        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        base.contentEdgeInsets = UIEdgeInsets(
            top: edgeOffset,
            left: 0.0,
            bottom: edgeOffset,
            right: 0.0
        )
    }
}

