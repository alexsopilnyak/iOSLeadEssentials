//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 07.04.2023.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    public typealias Result = LoadFeedResult
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result)-> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

extension RemoteFeedLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedItem] {
        map {
            FeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.image)
        }
    }
}
