//
//  Ariel.swift
//  ArielLite
//
//  Created by Tung CHENG on 11/16/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

public extension UIView {
    
    func align(_ attribute: NSLayoutConstraint.Attribute, to item: UIView, offset: CGFloat = 0, priority: UILayoutPriority = .defaultHigh) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: .equal, toItem: item, attribute: attribute, multiplier: 1, constant: offset)
        constraint.priority = priority
        return constraint
    }
    
    func attach(to item: UIView, padding: CGFloat = 0, direction: NSLayoutConstraint.Axis) -> NSLayoutConstraint {
        if case .horizontal = direction {
            return match(.leading, offset: padding, with: (item, .trailing))
        } else {
            return match(.top, offset: padding, with: (item, .bottom))
        }
    }
    
    func match(_ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, with target: (UIView, NSLayoutConstraint.Attribute)) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: target.0, attribute: target.1, multiplier: 1.0, constant: offset)
    }
    
    func edges(equal item: UIView, edgeInsets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) {
        let constraints = edges(equal: item, edgeInsets: edgeInsets)
        for constraint in constraints {
            constraint.priority = priority
            constraint.isActive = true
        }
    }
    
    /// ratio: width / height
    func aspect(ratio: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0.0)
        constraint.priority = priority
        return constraint
    }
    
    func set(_ attribute: NSLayoutConstraint.Attribute, to constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
        constraint.priority = priority
        return constraint
    }
    
    internal func edges(equal item: UIView, edgeInsets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(align(.leading, to: item, offset: edgeInsets.right))
        constraints.append(align(.trailing, to: item, offset: -edgeInsets.left))
        constraints.append(align(.top, to: item, offset: edgeInsets.top))
        constraints.append(align(.bottom, to: item, offset: -edgeInsets.bottom))
        return constraints
    }
}
