//
//  FeedCache'.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 05.10.2023.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
