//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Oleksandr Sopilniak on 08.04.2023.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to ap propriated threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
