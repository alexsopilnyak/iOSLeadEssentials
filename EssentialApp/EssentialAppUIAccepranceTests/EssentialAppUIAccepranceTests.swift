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

            XCTAssertEqual(app.cells.count, 22)
            XCTAssertEqual(app.cells.firstMatch.images.count, 1)
        }
}
