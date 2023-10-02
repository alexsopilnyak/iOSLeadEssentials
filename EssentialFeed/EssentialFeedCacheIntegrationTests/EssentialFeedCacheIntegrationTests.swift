//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Oleksandr Sopilniak on 24.05.2023.
//

import XCTest
import EssentialFeed    

final class EssentialFeedCacheIntegrationTests: XCTestCase {
    
    override func setUpWithError() throws {
        setupEmptyStoreState()
    }

    override func tearDownWithError() throws {
        undoStoreSideEffects()
    }

    func test_load_deliversNoItemsOnEmptyCache() throws {
        let sut = makeSUT()
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        save(feed, with: sutToPerformSave)
        
        expect(sutToPerformLoad, toLoad: feed)
    }
    
    func test_load_overrideItemsSavedOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformSecondSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueImageFeed().models
        let secondFeed = uniqueImageFeed().models

        save(firstFeed, with: sutToPerformFirstSave)
        save(secondFeed, with: sutToPerformSecondSave)
        
        expect(sutToPerformLoad, toLoad: secondFeed)
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        
        return sut
    }
    
    private func expect(
        _ sut: LocalFeedLoader,
        toLoad expectedFeed: [FeedImage],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Waiting for load completion")

        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
            case let .failure(error):
                XCTFail("Expected successfull feed result, got \(error) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    private func save(
        _ feed: [FeedImage],
        with sut: LocalFeedLoader,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let saveExp = expectation(description: "Waiting for save")
        sut.save(feed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully", file: file, line: line)
            saveExp.fulfill()
        }
        
        wait(for: [saveExp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
        
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    
    private func testSpecificStoreURL() -> URL {
        cachesDirectory()
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
