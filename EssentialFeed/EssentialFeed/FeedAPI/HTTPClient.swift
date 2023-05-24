//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 08.04.2023.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to ap propriated threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
