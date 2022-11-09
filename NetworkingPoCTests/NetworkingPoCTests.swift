//
//  NetworkingPoCTests.swift
//  NetworkingPoCTests
//
//  Created by Frank Solleveld on 09/11/2022.
//

import XCTest
@testable import NetworkingPoC

final class NetworkingPoCTests: XCTestCase {
    func test_UrlProtocolMock() {
        let url = URL(string: "https://github.com")
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "https://github.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let task = mockSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            guard let httpResponse = response as? HTTPURLResponse else {
                XCTFail("unexpected response")
                return
            }
            XCTAssertEqual(200, httpResponse.statusCode)
        })
        task.resume()
    }
}
