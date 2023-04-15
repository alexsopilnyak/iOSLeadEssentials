//
//  FeedApiMapper.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 08.04.2023.
//

import Foundation

final class FeedItemsMapper {
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}

private extension FeedItemsMapper {
    struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            items.map(\.feedItem)
        }
    }

    struct Item: Equatable, Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var feedItem: FeedItem {
            FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
}

