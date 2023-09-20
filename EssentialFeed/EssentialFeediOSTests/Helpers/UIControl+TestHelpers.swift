//
//  UIControl+testHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Sopilniak on 20.09.2023.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
