//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping (Result) -> Void)
}
