//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
