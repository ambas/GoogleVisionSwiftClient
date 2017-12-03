//
//  GoogleVisionSwiftClientTests.swift
//  GoogleVisionSwiftClientTests
//
//  Created by Ambas Chobsanti on 7/29/17.
//  Copyright © 2017 Ambas. All rights reserved.
//

import XCTest
@testable import GoogleVisionSwiftClient

private struct Config {
    static let GoogleAPIKey = ""
    static let ExpectedDetectedWordCount = 47
    static let UnexpectedDetectedWordCount = 10
    static let CorrectImageName = "sample JP.jpg"
    static let WrongImageName = "Scared-Cat-1.jpg"
    static let CanNotFindWordText = "Cant find any word"
}

typealias ConditionWordCount = (Int) -> Bool

class GoogleVisionSwiftClientTests: XCTestCase {

    let client = Client(googleAPIKey: Config.GoogleAPIKey)

    var correctImage: UIImage {
        return image(imageName: Config.CorrectImageName)
    }

    var wrongImage: UIImage {
        return image(imageName: Config.WrongImageName)
    }

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDetectCorrectWordsCount() {
        testDetectWordCount(image: correctImage) { $0 == Config.ExpectedDetectedWordCount }
    }

    func testDetectWrongWordsCount() {
        testDetectWordCount(image: correctImage) { $0 != Config.UnexpectedDetectedWordCount }
    }

    func testPerformOnMainThread() {
        let ex = self.expectation(description: "")
        client.detectWords(fromImage: correctImage) { _ in
            XCTAssertTrue(Thread.isMainThread, "")
            ex.fulfill()
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }

    func testCanNotFindAnyWordInImage() {
        let ex = self.expectation(description: "")
        client.detectWords(fromImage: wrongImage) { (result) in
            switch result {
            case .success:
                XCTFail("Should not success here")
            case let .error(error):
                print(error.localizedDescription)
                switch error.kind {
                case let .error(detail):
                    XCTAssertTrue(detail == Config.CanNotFindWordText)
                default:
                    XCTFail("Should return error with messafge")
                }
            }

            ex.fulfill()
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }

    fileprivate func image(imageName: String) -> UIImage {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)!
        return image
    }

    fileprivate func testDetectWordCount(image: UIImage, condition: @escaping ConditionWordCount) {
        let ex = self.expectation(description: "")
        client.detectWords(fromImage: image) { (result) in
            switch result {
            case let .success(detectedWords):
                XCTAssertTrue(condition(detectedWords.count))
            case let .error(error):
                XCTFail("Error with error: \(error)")
            }

            ex.fulfill()
        }
        self.waitForExpectations(timeout: 20, handler: nil)
    }

}
