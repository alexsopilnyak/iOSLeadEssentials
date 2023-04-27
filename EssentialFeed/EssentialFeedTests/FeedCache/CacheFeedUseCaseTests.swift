//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 27.04.2023.
//

import XCTest
import EssentialFeed

class FeedStore {
    var deleteCachedFeedCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
}

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
}

private extension CacheFeedUseCaseTests {
    func uniqueItem() -> FeedItem {
        FeedItem(id: UUID(), description: "any desc", location: "any loc", imageURL: anyURL())
    }
    
    func anyURL() -> URL { URL(string: "https://any-url.com")! }
}
