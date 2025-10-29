//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Дмитрий Шиляев on 20.10.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() {
        let poster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertTrue(poster.waitForExistence(timeout: 5), "Постер не появился")
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Индекс не появился")
        
        let firstPosterData = poster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertTrue(poster.waitForExistence(timeout: 5))
        let secondPosterData = poster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        let poster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertTrue(poster.waitForExistence(timeout: 5), "Постер не появился")
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Индекс не появился")
        
        let firstPosterData = poster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(indexLabel.label, "2/10")
        
        XCTAssertTrue(poster.waitForExistence(timeout: 5))
        let secondPosterData = poster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testGameFinish() {
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Индекс не появился")
        
        for i in 1...10 {
            app.buttons["No"].tap()

            if i < 10 {
                XCTAssertTrue(indexLabel.waitForExistence(timeout: 5))
                XCTAssertEqual(indexLabel.label, "\(i+1)/10")
            }
        }
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Алерт 'Game results' не появился")
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Индекс не появился")
        
        for _ in 1...10 {
            app.buttons["No"].tap()
            XCTAssertTrue(indexLabel.waitForExistence(timeout: 5))
        }

        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Алерт 'Game results' не появился")
        alert.buttons.firstMatch.tap()
        
        XCTAssertFalse(alert.waitForExistence(timeout: 2), "Алерт все еще отображается")
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5))
        XCTAssertEqual(indexLabel.label, "1/10")
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
