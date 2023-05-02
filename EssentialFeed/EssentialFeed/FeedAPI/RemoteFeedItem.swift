//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 02.05.2023.
//

import Foundation

struct RemoteFeedItem: Equatable, Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
