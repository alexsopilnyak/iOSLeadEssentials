//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Oleksandr Sopilniak on 24.05.2023.
//

import XCTest
import EssentialFeed    

final class EssentialFeedCacheIntegrationTests: XCTestCase {

    func test_load_deliversNoItemsOnEmptyCache() throws {
        let sut = makeSUT()
        let exp = expectation(description: "Waiting for load completion")
        
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, [], "Expected empty feeed")
            case let .failure(error):
                XCTFail("Expected successfull feed result, got \(error) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        cachesDirectory()
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
