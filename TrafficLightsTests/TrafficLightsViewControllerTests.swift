//
//  TrafficLightsTests.swift
//  TrafficLightsTests
//
//  Created by Sasha Belov on 7.10.24.
//

import XCTest
@testable import TrafficLights

class TrafficLightsViewControllerTests: XCTestCase {

    var sut: TrafficLightsViewController!

    override func setUpWithError() throws {
        super.setUp()
        sut = TrafficLightsViewController()
        sut.setupMakeAndModel(make: "Lexus", model: "is300")
        sut.setupUI()
        sut.loadViewIfNeeded() // Load the view to set up UI
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testSetupMakeAndModel() {
        XCTAssertEqual(sut.make, "Lexus", "Make should be set correctly.")
        XCTAssertEqual(sut.model, "is300", "Model should be set correctly.")
        XCTAssertEqual(sut.makeModelLabel.text, "Lexus is300", "Make and model label should display correct text.")
    }
    
    func testTrafficLightUpdate() {
        sut.currentLightIndex = 0
        
        sut.updateTrafficLight()
        
        XCTAssertEqual(sut.redLightView.backgroundColor?.cgColor.alpha, 1.0, "Red light should be fully visible.")
        XCTAssertEqual(sut.orangeLightView.backgroundColor?.cgColor.alpha, 0.2, "Orange light should be dimmed.")
        XCTAssertEqual(sut.greenLightView.backgroundColor?.cgColor.alpha, 0.2, "Green light should be dimmed.")
        
        sut.currentLightIndex = 1 // Change to orange
        sut.updateTrafficLight()
        
        XCTAssertEqual(sut.redLightView.backgroundColor?.cgColor.alpha, 0.2, "Red light should be dimmed.")
        XCTAssertEqual(sut.orangeLightView.backgroundColor?.cgColor.alpha, 1.0, "Orange light should be fully visible.")
        XCTAssertEqual(sut.greenLightView.backgroundColor?.cgColor.alpha, 0.2, "Green light should be dimmed.")
        
        sut.currentLightIndex = 2 // Change to green
        sut.updateTrafficLight()
        
        XCTAssertEqual(sut.redLightView.backgroundColor?.cgColor.alpha, 0.2, "Red light should be dimmed.")
        XCTAssertEqual(sut.orangeLightView.backgroundColor?.cgColor.alpha, 0.2, "Orange light should be dimmed.")
        XCTAssertEqual(sut.greenLightView.backgroundColor?.cgColor.alpha, 1.0, "Green light should be fully visible.")
    }
}
