//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 02.10.2023.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
