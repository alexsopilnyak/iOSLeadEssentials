//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 15.04.2023.
//

import Foundation
import XCTest 

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be dealocated. Memory leak", file: file, line: line)
        }
    }
}
