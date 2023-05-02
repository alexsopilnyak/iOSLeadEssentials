//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 02.05.2023.
//

import Foundation

struct LocalFeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    init(
        id: UUID,
        description: String?,
        location: String?,
        imageURL: URL
    ) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
