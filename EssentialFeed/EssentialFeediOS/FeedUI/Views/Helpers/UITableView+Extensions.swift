//
//  UITableView+Extensions.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Sopilniak on 24.09.2023.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(String(describing: T.self))
        
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
