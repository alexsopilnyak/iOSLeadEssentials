//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 28.04.2023.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult ) -> Void
    
    // The completion hadler can be invoked in any thread
    // Clients are responsible to dispatch to appropriated threads, if needed
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    // The completion hadler can be invoked in any thread
    // Clients are responsible to dispatch to appropriated threads, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    // The completion hadler can be invoked in any thread
    // Clients are responsible to dispatch to appropriated threads, if needed
    func retrieve(completion: @escaping RetrievalCompletion)
}
