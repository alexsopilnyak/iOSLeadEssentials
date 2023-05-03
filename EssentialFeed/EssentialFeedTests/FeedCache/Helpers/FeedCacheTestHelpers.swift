//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 03.05.2023.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any desc", location: "any loc", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map {
        LocalFeedImage (id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }
    
    return (items, localItems)
}

extension Date {
    func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
