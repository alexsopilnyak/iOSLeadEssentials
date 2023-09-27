//
//  UIRefreshControl+Extensions.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Sopilniak on 27.09.2023.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
