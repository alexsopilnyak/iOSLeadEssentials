//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 06.04.2023.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
}
