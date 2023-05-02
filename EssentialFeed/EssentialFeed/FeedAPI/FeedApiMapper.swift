//
//  FeedApiMapper.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 08.04.2023.
//

import Foundation

final class FeedItemsMapper {
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem ] {
        guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}

private extension FeedItemsMapper {
    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
}
