//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Sopilniak on 08.10.2023.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit(){
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let needsUpdateFrame = header.frame.height != size.height
        if needsUpdateFrame {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
