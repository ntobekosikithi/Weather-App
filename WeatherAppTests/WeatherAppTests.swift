//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Ntobeko on 2018/09/13.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherClientData() {
        
        let testExpectationCurrent = expectation(description: "Current weather")
        let testExpectationForecast = expectation(description: "Forecast weather")

        let viewController = WeatherViewController()
        let WeatherClient = WeatherAPIClient()
        viewController.setupLocation()
        let location = viewController.getLocation()
        XCTAssertNotNil(location)
        WeatherClient.current(weatherData: .getCurrentWeather, lat:String(location.latitude) , lon: String(location.longitude), completion: { results in
            switch results {
            case .success(let weather):
                XCTAssertNotNil(weather)
                testExpectationCurrent.fulfill()
            case .failure:
                XCTFail()
            }
        })

        WeatherClient.forecast(weatherData: .getForecast, lat: String(location.latitude), lon: String(location.longitude), completion: { results in
            switch results {
            case .success(let forecast):
                XCTAssertNotNil(forecast)
                testExpectationForecast.fulfill()
            case .failure:
                XCTFail()
            }
        })
        waitForExpectations(timeout: 12, handler: .none)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
