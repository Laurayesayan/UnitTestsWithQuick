//
//  UnitTestsWithQuick_2_18Tests.swift
//  UnitTestsWithQuick_2_18Tests
//
//  Created by Лаура Есаян on 22.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
import OHHTTPStubs

@testable import UnitTestsWithQuick_2_18

class UnitTestsWithQuick_2_18Tests: QuickSpec {
    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }
    
    override func spec() {
        describe("ArraySorter tests") {
            it("is ok") {
                expect(ArraySorter(array: [3, 2, 8, 5]).bubbleSort()).to(equal([2, 3, 5, 8]))
                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).gnomeSort()).to(equal([-8, -5, 0.3, 1.5]))
                expect(ArraySorter(array: [10, 9.2, 100, -0.1]).insertionSort()).to(equal([-0.1, 9.2, 10, 100]))
                
                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).getMinimum()).to(equal(-8))
                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).getMaximum()).to(equal(1.5))
            }
        }
        
        describe("RealmTests") {
            Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
            
            let human1 = createHuman(name: "Alex", height: 183, weight: 80.5, dateOfBirth: "1992/02/12")
            HumanHandler.shared.addHuman(human: human1)
            let human2 = createHuman(name: "Lessia", height: 173, weight: 60.5, dateOfBirth: "1990/07/15")
            HumanHandler.shared.addHuman(human: human2)
            let human3 = createHuman(name: "Annie", height: 158, weight: 53.5, dateOfBirth: "1994/05/11")
            HumanHandler.shared.addHuman(human: human3)
            
            expect(HumanHandler.shared.getTheOldestHuman()?.name).to(equal(human2.name))
            
            expect(HumanHandler.shared.getTheYoungestHuman()?.name).to(equal(human3.name))
            
            expect(HumanHandler.shared.removeHuman(human: human3)).to(equal(true))
            
            expect(HumanHandler.shared.getTheYoungestHuman()?.dateOfBirth).to(equal(human1.dateOfBirth))
        }
        
        stub(condition: isHost("api.openweathermap.org")) { _ in
            let stubPath = OHPathForFile("Weather.json", type(of: self))
            // Imitation of slow request and response time.
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"]).requestTime(1.0, responseTime: 2.0)
        }
        
        var weatherDicts: [WeatherDict] = []
        let e = expectation(description: "Waiting for json")
        WeatherLoader().loadHourlyWeather { weatherDict in
            weatherDicts = weatherDict
            describe("Request results tests") {
                expect(weatherDicts.count).to(equal(8))
                expect(weatherDicts[0].hourly.temperature).to(equal(284.01))
                expect(weatherDicts[0].hourly.rainProbability).to(beNil())
                expect(weatherDicts[1].hourly.rainProbability).to(equal(0.13))
                expect(weatherDicts[1].hourly.windSpeed).to(equal(0.88))
            }
            e.fulfill()
        }
        
        
        waitForExpectations(timeout: 3.5, handler: nil)
    }
    
    func createHuman(name: String, height: Float, weight: Float, dateOfBirth: String) -> Human {
        let human = Human()
        human.name = name
        human.height = height
        human.weight = weight
        human.dateOfBirth = getDate(date: dateOfBirth)
        
        return human
    }
    
    func getDate(date: String) -> Date {
        var dateOfBirth = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        dateOfBirth = dateFormater.date(from: date)!
        
        return dateOfBirth
    }
    
}
