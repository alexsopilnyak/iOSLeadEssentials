//
//  LocalImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 02.10.2023.
//

import XCTest
final class LocalImageDataLoader {
    init(store: Any) {}
}

final class LocalImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessagesStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
}

private extension LocalImageDataLoaderTests {
    func makeSUT() -> (sut: LocalImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalImageDataLoader(store: store)
        
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return (sut, store)
    }
    
    final class FeedStoreSpy {
        var receivedMessages = [Any]()
    }
}
