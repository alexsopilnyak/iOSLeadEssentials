//
//  EssentialAppUIAccepranceTests.swift
//  EssentialAppUIAccepranceTests
//
//  Created by Oleksandr Sopilniak on 05.10.2023.
//

import XCTest

final class EssentialAppUIAccepranceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 22)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)
    }
}
