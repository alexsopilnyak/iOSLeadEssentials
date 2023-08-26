//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
