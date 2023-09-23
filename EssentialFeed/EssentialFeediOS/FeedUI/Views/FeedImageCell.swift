//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Sopilniak on 27.08.2023.
//

import Foundation
import UIKit

public final class FeedImageCell: UITableViewCell {
    @IBOutlet private(set) public var locationContainer: UIView!
        @IBOutlet private(set) public var locationLabel: UILabel!
        @IBOutlet private(set) public var feedImageContainer: UIView!
        @IBOutlet private(set) public var feedImageView: UIImageView!
        @IBOutlet private(set) public var feedImageRetryButton: UIButton!
        @IBOutlet private(set) public var descriptionLabel: UILabel!
    
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
