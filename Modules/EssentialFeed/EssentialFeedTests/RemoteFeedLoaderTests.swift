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
         
        sut.load {_ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://a-url.com")!
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500]
            .enumerated()
            .forEach { index, code in
                expect(sut, toCompleteWithError: .invalidData) {
                    client.complete(withStatusCode: code, at: index)
                }
            }
    }
    
    func test_load_deliversErrorOn200ResponseCodeWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON = Data("ivalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliverNoItemsOn200StatusCodeWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load {
            capturedResults.append($0)
        }
        
        let jsonData = Data("{\"items\": []}".utf8)
        
        client.complete(withStatusCode: 200, data: jsonData)
        
        XCTAssertEqual(capturedResults, [.success([])])

    }

    // MARK: - Helpers
    
    func expect(
        _ sut: RemoteFeedLoader,
        toCompleteWithError error: RemoteFeedLoader.Error,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
            var capturedResults = [RemoteFeedLoader.Result]()
            
            sut.load {
                capturedResults.append($0)
            }
            
            action()
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
        }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            messages.map(\.url)
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }
    
    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        client: HTTPClientSpy = HTTPClientSpy()
    ) -> (RemoteFeedLoader, HTTPClientSpy) {
        (RemoteFeedLoader(url: url, client: client), client)
    }
}
