//
//  UITableView+Extension.swift
//  Pods-XUIKit_Example
//
//  Created by FITZ on 2022/4/24.
//

import UIKit

public extension XUIKitWrapper where Base: UITableView {
    /// 不带动画 更新
    func updateWithoutAnimate(_ block: (UITableView) -> ()) {
        UIView.setAnimationsEnabled(false)
        base.beginUpdates()
        block(base)
        base.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    /// cell复用
    func dequeueReusableCell(withIdentifier: String) -> Any! {
        var cell = base.dequeueReusableCell(withIdentifier: withIdentifier)
        if cell == nil {
            let c = NSClassFromString(withIdentifier)! as! UITableViewCell.Type
            cell = c.init(style: .default, reuseIdentifier: withIdentifier)
        }
        return (cell as Any)
    }
    
    func registerCellClass(_ cellClass: Swift.AnyClass) -> () {
        base.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }

    func registerCellNib(_ cellClass: Swift.AnyClass) -> () {
        let classString = NSStringFromClass(cellClass)
        guard let className =  classString.components(separatedBy:".").last else {
            return
        }
        let nib = UINib.init(nibName: className , bundle: nil)
        base.register(nib, forCellReuseIdentifier: classString)
    }

    func dequeue<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        base.dequeueReusableCell(withIdentifier: NSStringFromClass(cellType), for: indexPath) as! T
    }

    func registerHeaderFooterClass<T: UITableViewHeaderFooterView>(_ clazz: T.Type) -> () {
        base.register(clazz, forHeaderFooterViewReuseIdentifier: NSStringFromClass(clazz))
    }

    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_ clazz: T.Type) -> () {
        let nib = UINib.init(nibName: NSStringFromClass(clazz), bundle: nil)
        base.register(nib, forHeaderFooterViewReuseIdentifier: NSStringFromClass(clazz))
    }

    func dequeHeaderFooter<T: UITableViewHeaderFooterView>(viewType: T.Type) -> T {
        base.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(viewType)) as! T
    }
}

