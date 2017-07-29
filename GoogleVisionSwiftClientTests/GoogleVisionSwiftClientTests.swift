//
//  GoogleVisionSwiftClientTests.swift
//  GoogleVisionSwiftClientTests
//
//  Created by Ambas Chobsanti (Lazada Group) on 7/29/17.
//  Copyright © 2017 Ambas. All rights reserved.
//

import XCTest
@testable import GoogleVisionSwiftClient

let googleAPIKey = ""

class GoogleVisionSwiftClientTests: XCTestCase {

    let client = Client(googleAPIKey: googleAPIKey)

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDetectWords() {
        let ex = self.expectation(description: "SomeService does stuff and runs the callback closure")
        let bundle = Bundle(for: type(of: self))

        let image = UIImage(named: "Scared-Cat-1.jpg", in: bundle, compatibleWith: nil)!
        client.detectWords(fromImage: image) { (result) in
            switch result {
            case let .success(detectedWords):
                XCTAssert(detectedWords.count == 83)
            case .error:
                XCTAssert(false)
            }

            ex.fulfill()
        }
        self.waitForExpectations(timeout: 100, handler: nil)
    }

}
