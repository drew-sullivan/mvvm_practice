//
//  ItemListViewControllerTest.swift
//  MVVMSampleTests
//
//  Created by Drew Sullivan on 1/7/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import XCTest

@testable import MVVMSample

class ItemListViewControllerTest: XCTestCase {
    
    var sut: ItemListViewController!

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        
        sut = vc as? ItemListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func test_table_view_is_not_nil_after_viewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_loading_view_sets_table_view_data_source() {
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_loading_view_sets_table_view_delegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_loading_view_datasource_equals_delegate() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
    }

}
