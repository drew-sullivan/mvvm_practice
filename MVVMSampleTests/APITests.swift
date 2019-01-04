//
//  APITests.swift
//  MVVMSampleUITests
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import Foundation
import XCTest

@testable import MVVMSample

class APITests: XCTestCase {
    
    var apiClient: APIClient!
    var mockURLSession: MockURLSession!
    var mockJSONData: Data!

    override func setUp() {
        super.setUp()
        
        apiClient = APIClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        apiClient.session = mockURLSession
        
        mockJSONData = "[{\"albumId\": 1,\"id\": 1,\"title\": \"accusamus beatae ad facilis cum similique qui sunt\",\"url\": \"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\": \"https://via.placeholder.com/150/92c952\"},{\"albumId\": 1,\"id\": 2,\"title\": \"reprehenderit est deserunt velit ipsam\",\"url\": \"https://via.placeholder.com/600/771796\",\"thumbnailUrl\": \"https://via.placeholder.com/150/771796\"}]".data(using: .utf8)
    }

    override func tearDown() {
        mockJSONData = nil
        mockURLSession = nil
        apiClient = nil
        
        super.tearDown()
    }

    func test_fetchData_creates_photo_array() {
        mockURLSession = MockURLSession(data: mockJSONData, urlResponse: nil, error: nil)
        apiClient.session = mockURLSession
        
        let photoExpectation = expectation(description: "Photo")
        var receivedPhotos: [Photo]?
        apiClient.fetchData { (photos, _) in
            receivedPhotos = photos
            photoExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedPhotos)
            XCTAssert(receivedPhotos!.count > 0, "Not enough photos added")
        }
    }
    
    func test_fetchData_when_JSON_is_invalid_returns_error() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        apiClient.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        
        var caughtError: Error? = nil
        apiClient.fetchData { (photo, error) in
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func test_fetchData_when_response_has_error_returns_error() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        
        mockURLSession = MockURLSession(data: mockJSONData, urlResponse: nil, error: error)
        apiClient.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        
        var caughtError: Error? = nil
        apiClient.fetchData { (photo, error) in
            caughtError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func test_APIClient_uses_expected_host() {
        let completion = { (photo: [Photo]?, error: Error?) in }
        apiClient.fetchData(completion: completion)

        XCTAssertEqual(mockURLSession.urlComponents?.host, "jsonplaceholder.typicode.com")
    }

    func test_APIClient_uses_expected_path_for_photos() {
        let completion = { (photo: [Photo]?, error: Error?) in }
        apiClient.fetchData(completion: completion)

        XCTAssertEqual(mockURLSession.urlComponents?.path, "/photos")
    }

}

extension APITests {
    
    
    class MockURLSession: SessionProtocol {
        
        var url: URL?
        private let dataTask: MockTask
        
        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
        
    }
    
    
    class MockTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async() {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
        
    }
    
}
