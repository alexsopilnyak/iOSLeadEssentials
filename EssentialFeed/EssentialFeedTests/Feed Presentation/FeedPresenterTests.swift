//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 28.09.2023.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
}

private extension FeedPresenterTests {
    class ViewSpy {
        let messages = [Any]()
    }
}
