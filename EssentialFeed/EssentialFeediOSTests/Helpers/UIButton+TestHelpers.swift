//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Sopilniak on 20.09.2023.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
