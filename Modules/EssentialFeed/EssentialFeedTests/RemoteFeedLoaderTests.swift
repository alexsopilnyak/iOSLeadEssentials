//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import XCTest
let urlExample = URL(string: "https://a-url.com")!

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: urlExample )
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: urlExample, client: client)
        
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: urlExample, client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    
}
