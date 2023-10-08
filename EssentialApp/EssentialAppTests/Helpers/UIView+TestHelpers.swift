//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Oleksandr Sopilniak on 08.10.2023.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}

