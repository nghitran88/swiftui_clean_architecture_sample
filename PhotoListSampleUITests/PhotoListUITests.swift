//
//  PhotoListUITests.swift
//  PhotoListSampleUITests
//
//  Created by Nghi Tran on 22/1/25.
//

import XCTest
import Combine

final class PhotoListUITests: XCTestCase {
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testPhotoListLoadsDataSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        let goToPhotoListButton = app.buttons[Constants.UIComponentIDs.goToPhotoListButton]
        XCTAssertTrue(goToPhotoListButton.exists, "\(Constants.UIComponentIDs.goToPhotoListButton) not found")

        goToPhotoListButton.tap()
        
        // Check if the first cell loaded
        let photoCell = app.staticTexts["\(Constants.UIComponentIDs.photoListCell)1"]
        XCTAssertTrue(photoCell.waitForExistence(timeout: 2), "No photos loaded")

        // Check the number of loaded cells on the screen
        let cellPredicate = NSPredicate(format: "identifier like '\(Constants.UIComponentIDs.photoListCell)*'")
        let photoCells = app.staticTexts.matching(cellPredicate)
//        XCTAssertEqual(photoCells.count, 10, "Not enough cells generated")
        XCTAssertGreaterThanOrEqual(photoCells.count, 5, "Not enough cells generated")
    }
    
    func testGoToDetailSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        let goToPhotoListButton = app.buttons[Constants.UIComponentIDs.goToPhotoListButton]
        XCTAssertTrue(goToPhotoListButton.exists, "\(Constants.UIComponentIDs.goToPhotoListButton) not found")

        goToPhotoListButton.tap()
        
        // Check if the first cell loaded
        let photoCell = app.staticTexts["\(Constants.UIComponentIDs.photoListCell)1"]
        XCTAssertTrue(photoCell.waitForExistence(timeout: 2), "No photos loaded")

        photoCell.tap()
        
        let photoDetailTitle = app.staticTexts[Constants.UIComponentIDs.photoDetailScreenTitle]
        XCTAssertTrue(photoDetailTitle.waitForExistence(timeout: 2), "Failed to navigate to the Photo Detail screen")
    }
}
