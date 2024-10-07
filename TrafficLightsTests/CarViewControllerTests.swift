//
//  CarViewControllerTests.swift
//  TrafficLightsTests
//
//  Created by Sasha Belov on 7.10.24.
//

import XCTest
@testable import TrafficLights

class CarViewControllerTests: XCTestCase {
    
    var sut: CarViewController!

    override func setUpWithError() throws {
        super.setUp()
        sut = CarViewController()
        sut.loadCars()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testLoadCars() throws {
        XCTAssertFalse(sut.cars.isEmpty, "Cars should not be empty after loading.")
        XCTAssertFalse(sut.makes.isEmpty, "Makes should not be empty after loading.")
    }
    
    func testUpdateModelsForSelectedMake() {
        sut.cars = [
            Car(make: "BMW", models: ["1-series", "2-series"]),
            Car(make: "Audi", models: ["A1", "A2"])
        ]
        
        sut.updateModelsForMake("BMW")
        
        XCTAssertEqual(sut.models, ["1-series", "2-series"], "Models should match the selected make.")
    }
}
