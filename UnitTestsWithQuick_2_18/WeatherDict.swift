//
//  WeatherDict.swift
//  UnitTestsWithQuick_2_18
//
//  Created by Лаура Есаян on 24.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation
import OHHTTPStubs
import Alamofire

struct WeatherDict {
    
    let hourly: Hourly
    
    struct Hourly {
        let temperature: Double
        let windSpeed: Double
        var rainProbability: Double? = nil
        let time: Int64
        
        init?(data: NSDictionary) {
            guard let temperature = data["temp"] as? Double,
                let windSpeed = data["wind_speed"] as? Double,
                let time = data["dt"] as? Int64 else {
                    return nil
            }
            
            if let rain = data["rain"] as? NSDictionary {
                self.rainProbability = rain["1h"] as? Double
            }
            
            self.temperature = temperature
            self.windSpeed = windSpeed
            self.time = time
        }
    }
    
    
    init?(data: NSDictionary) {
        guard let hourly = Hourly(data: data) else {
                return nil
        }
        self.hourly = hourly
    }
}

class WeatherLoader {
    func loadHourlyWeather(completion: @escaping ([WeatherDict]) -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=55.75222&lon=37.61556&daily&appid=25d13511e3a337c6eb628b9c5dc086bf").responseJSON {
            response in
            if let json = response.value,
                let jsonDict = json as? NSDictionary {
                if let jsonDictList = jsonDict["hourly"] as? NSArray {
                    var weatherDicts: [WeatherDict] = []
                    for data in jsonDictList {
                        if let data = data as? NSDictionary {
                            if let weatherDict = WeatherDict(data: data){
                                weatherDicts.append(weatherDict)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(weatherDicts)
                    }
                }
                
            }
            
        }
    }
}
