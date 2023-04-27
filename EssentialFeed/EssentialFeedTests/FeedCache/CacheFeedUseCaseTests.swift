//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 27.04.2023.
//

import XCTest

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class LocalFeedLoader {
    init(store: FeedStore) {}
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
}
