//
//  ItemListDataProviderTests.swift
//  MVVMSampleTests
//
//  Created by Drew Sullivan on 1/7/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import XCTest

@testable import MVVMSample

class ItemListDataProviderTests: XCTestCase {
    
    var sut: ItemListDataProvider!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        
        sut = ItemListDataProvider()
        sut.manager = Manager.shared
        tableView = UITableView()
        tableView.dataSource = sut
    }

    override func tearDown() {
        
        
        super.tearDown()
    }

    func test_number_of_sections_is_2() {
        XCTAssertEqual(tableView.numberOfSections, 2)
    }
    
    func test_num_rows_in_section_1_is_photo_count() {
        sut.manager?.addPhoto(Photo(isSample: true))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.manager?.addPhoto(Photo(isSample: true))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

}
