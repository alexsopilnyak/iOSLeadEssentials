//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Oleksandr Sopilniak on 04.10.2023.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
