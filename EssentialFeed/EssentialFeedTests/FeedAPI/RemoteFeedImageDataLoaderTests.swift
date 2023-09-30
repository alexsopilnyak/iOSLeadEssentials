//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 30.09.2023.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    init(client: Any) {}
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
}

extension RemoteFeedImageDataLoaderTests {
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
            let client = HTTPClientSpy()
            let sut = RemoteFeedImageDataLoader(client: client)
            trackForMemoryLeaks(sut, file: file, line: line)
            trackForMemoryLeaks(client, file: file, line: line)
            return (sut, client)
        }

        private class HTTPClientSpy {
            var requestedURLs = [URL]()
        }
}
