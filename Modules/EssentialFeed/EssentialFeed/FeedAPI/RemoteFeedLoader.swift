//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 07.04.2023.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error)-> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(response):
                break
//                completion(.invalidData)
            case let .failure(error):
                completion(.connectivity)
            }
        }
    }
}

extension RemoteFeedLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}
