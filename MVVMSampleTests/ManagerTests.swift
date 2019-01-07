//
//  ManagerTests.swift
//  MVVMSampleTests
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import XCTest

@testable import MVVMSample

class ManagerTests: XCTestCase {
    
    var manager: Manager!

    override func setUp() {
        super.setUp()
        
        manager = Manager.shared
    }

    override func tearDown() {
        manager.clearPhotos()
        manager = nil
        
        super.tearDown()
    }
    
    func test_photo_at_returns_photo_at_given_index() {
        manager.addPhoto(Photo(isSample: true))
        let returnedPhoto = manager.photo(at: 0)
        XCTAssertEqual(returnedPhoto, Photo(isSample: true), "Returned incorrect photo")
    }
    
    func test_clear_removes_all_photos() {
        XCTAssertEqual(manager.numPhotos(), 0)
    }
    
    func test_numPhotos_returns_0() {
        XCTAssertEqual(manager.numPhotos(), 0)
    }
    
    func test_addPhoto_add_photo() {
        let numPhotosBeforeAdd = manager.numPhotos()
        manager.addPhoto(Photo(isSample: true))
        XCTAssertEqual(manager.numPhotos(), numPhotosBeforeAdd + 1)
    }
}
