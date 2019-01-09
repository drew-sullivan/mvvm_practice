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
    
    var vc: ItemListViewController!
    var sut: ItemListDataProvider!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        
        
        sut = ItemListDataProvider()
        sut.manager = Manager.shared
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        vc.loadViewIfNeeded()
        
        tableView = vc.tableView
        tableView.dataSource = sut
    }

    override func tearDown() {
        tableView = nil
        sut.manager?.clearPhotos()
        sut = nil
        
        super.tearDown()
    }
    
    func test_num_rows_in_section_1_is_photo_count() {
        sut.manager?.addPhoto(Photo(isSample: true))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.manager?.addPhoto(Photo(isSample: true))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_cellForRow_returns_PhotoCell() {
        sut.manager?.addPhoto(Photo(isSample: true))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssert(cell is PhotoCell)
    }
    
    func test_cellforRow_dequeues_cell_from_table_view() {
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        mockTableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        
        sut.manager?.addPhoto(Photo(isSample: true))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellWasDequeued)
    }
    
    func test_cellForRow_call_config_cell() {
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        mockTableView.register(MockTableCell.self, forCellReuseIdentifier: "MockTableCell")
        let photo = Photo(isSample: true)
        sut.manager?.addPhoto(photo)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTableCell
        
        XCTAssertEqual(cell.caughtPhoto, photo)
    }

}

extension ItemListDataProviderTests {
    
    class MockTableView: UITableView {
        var cellWasDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellWasDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    class MockTableCell: PhotoCell {
        var caughtPhoto: Photo?
        
        override func configCell(with photo: Photo) {
            caughtPhoto = photo
        }
    }
}
