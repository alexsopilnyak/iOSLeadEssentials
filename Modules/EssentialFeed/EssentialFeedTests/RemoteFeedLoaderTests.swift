//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://a-url.com")!
         
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://a-url.com")!
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load {
            capturedError.append($0) // == completion(.connectivity)
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }

    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion) // == { capturedError.append($0) }
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
    
    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        client: HTTPClientSpy = HTTPClientSpy()
    ) -> (RemoteFeedLoader, HTTPClientSpy) {
        (RemoteFeedLoader(url: url, client: client), client)
    }
}
