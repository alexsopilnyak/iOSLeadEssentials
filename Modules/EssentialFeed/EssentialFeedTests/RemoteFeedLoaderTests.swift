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
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500]
            .enumerated()
            .forEach { index, code in
                expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                    client.complete(withStatusCode: code, at: index)
                }
            }
    }
    
    func test_load_deliversErrorOn200ResponseCodeWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("ivalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliverNoItemsOn200StatusCodeWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([])) {
            let jsonData = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: jsonData)
        }
    }
    
    func test_load_deliversItemsOn200StatusCode() {
        let (sut, client) = makeSUT()
        let pair1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://a-url.com")!
        )
        
        let pair2 = makeItem(
            id: UUID(),
            description: "Desc",
            location: "loc",
            imageURL: URL(string: "https://a-url23423.com")!
        )
        
        let jsonData = makeItemsData([pair1.json, pair2.json])
        
        expect(sut, toCompleteWithResult: .success([pair1.item, pair2.item])) {
           
            client.complete(withStatusCode: 200, data: jsonData)
        }
        
    }

    // MARK: - Helpers
    
    func makeItem(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        imageURL: URL
    ) -> (item: FeedItem, json: [String: Any]) {
        let item = FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: imageURL
        )
        
        let jsonDict = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (item, jsonDict)
    }
    
    func makeItemsData(_ itemsJsons: [[String: Any]]) -> Data {
        let json = ["items": itemsJsons]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    func expect(
        _ sut: RemoteFeedLoader,
        toCompleteWithResult result: RemoteFeedLoader.Result,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
            var capturedResults = [RemoteFeedLoader.Result]()
            
            sut.load {
                capturedResults.append($0)
            }
            
            action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
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
