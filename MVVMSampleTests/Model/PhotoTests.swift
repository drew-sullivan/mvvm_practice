//
//  PhotoTests.swift
//  MVVMSampleUITests
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import XCTest

@testable import MVVMSample

class PhotoTests: XCTestCase {
    
    var photo: Photo!

    override func setUp() {
        super.setUp()
        
        photo = Photo(isSample: true)
    }
    
    override func tearDown() {
        photo = nil
        
        super.tearDown()
    }
    
    func test_init_with_literal_data_sets() {
        let photo = Photo(albumID: 1, id: 1, title: "test-photo", url: "https://test.com", thumbnailURL: "https://testtnail.com")
        XCTAssertEqual(photo.title, "test-photo")
    }
    
    func test_init_with_sample_data_is_sample_data() {
        let photo = Photo(isSample: true)
        XCTAssertEqual(photo.id, 17)
    }
    
    func test_photoURL_is_set() {
        XCTAssertNotNil(photo.photoURL)
    }
    
    func test_thumbnailLocationURL_is_set() {
        XCTAssertNotNil(photo.thumbnailLocationURL)
    }

}
