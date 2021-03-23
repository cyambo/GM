//
//  NetworkTest.swift
//  iTunes SearchTests
//
//  Created by Cristiana Yambo on 3/23/21.
//

import XCTest
@testable import iTunes_Search
class NetworkTest: XCTestCase {
    //Data returned by mocked network request
    static var completionData: Data?
    //Mocked networking to return above completion data in mocked requests
    class NetworkConfigTest: NetworkConfig {
        override func dataTask(session: URLSession, request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
            completionHandler(completionData,nil,nil)
            return nil
        }
    }

    /// Tests empty data
    func testRequestNilData() {
        let c = NetworkConfigTest.init()
        let n = Network.init(c)
        NetworkTest.completionData = nil
        let excpectation = self.expectation(description: "Request must be called")
        n.sendRequest("Search") { (data) in
            XCTAssertNil(data, "Data must be nil")
            excpectation.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    /// Tests with a good JSON response
    func testGoodJson() {
        guard let file = loadJson("goodJson") else {
            XCTFail("Could not load file 'goodJson.json'")
            return
        }

        let c = NetworkConfigTest.init()
        let n = Network.init(c)
        NetworkTest.completionData = file
        let excpectation = self.expectation(description: "Request must be called")
        n.sendRequest("Search") { (data) in
            XCTAssertNotNil(data, "Data must not be nil")
            XCTAssertEqual(2, data?.resultCount, "Data must have 2 results")
            XCTAssertEqual(2, data?.results?.count, "Data result array must have 2 results" )
            excpectation.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    /// Tests with a bad json response
    func testBadJson() {
        guard let file = loadJson("badJson") else {
            XCTFail("Could not load file 'badJson.json'")
            return
        }

        let c = NetworkConfigTest.init()
        let n = Network.init(c)
        NetworkTest.completionData = file
        let excpectation = self.expectation(description: "Request must be called")
        n.sendRequest("Search") { (data) in
            XCTAssertNotNil(data, "Data should be nil")
            excpectation.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    /// Loads a json file into Data
    /// - Parameter path: JSON file to load
    /// - Returns: Data of JSON file
    func loadJson(_ path: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: path, ofType: "json") else { return nil }
        return NSData(contentsOfFile: path) as Data?
    }
}
