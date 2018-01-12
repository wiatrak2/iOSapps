//
//  Utils.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 12.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct pollutionData {
    
    var stationName: String
    var stationId: Int?
    var stPolutionIndex: Int
    var sensors: [Sensor]
    var sensorInfo: [(Int, String)]
    var pollutionParticulatesIndex: PolutionLevelIndex?
    var pollutionParticulatesLabel: [String:Int]
    
    init() {
        self.stationName = "NO DATA"
        self.stationId = nil
        self.stPolutionIndex = 404
        self.sensors = []
        self.sensorInfo = []
        self.pollutionParticulatesIndex = nil
        self.pollutionParticulatesLabel = ["404":404]
    }
    
    mutating func getSensorsInfo()  {
        var sensorsInfo:[(Int, String)] = []
        for sensor in self.sensors {
            guard let id = sensor.id else { continue }
            guard let param = sensor.param else { continue }
            guard let formula = param.paramFormula else { continue }
            sensorsInfo.append((id, formula))
        }
        self.sensorInfo = sensorsInfo
    }
    
    mutating func getPariculatesLabel() {
        var particulateLabel:Int = 404
        guard let particIndex = self.pollutionParticulatesIndex else { return }
        if let pm25 = particIndex.pm25IndexLevel  { particulateLabel = pm25.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["PM 2.5"] = particulateLabel
        if let pm10 = particIndex.pm10IndexLevel  { particulateLabel = pm10.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["PM 10"] = particulateLabel
        if let o3 = particIndex.o3IndexLevel  { particulateLabel = o3.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["O3"] = particulateLabel
        if let so2 = particIndex.so2IndexLevel  { particulateLabel = so2.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["SO2"] = particulateLabel
        if let co = particIndex.coIndexLevel  { particulateLabel = co.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["CO"] = particulateLabel
        if let no2 = particIndex.no2IndexLevel  { particulateLabel = no2.id ?? 404 } else { particulateLabel = 404 }
        self.pollutionParticulatesLabel["NO2"] = particulateLabel
    }
    
}

let polutionLevelColors: [Int:UIColor] = [
    0: UIColor(red: 0.4, green: 0.95, blue: 0.2, alpha: 1.0),
    1: UIColor(red: 0.5, green: 0.85, blue: 0.3, alpha: 1.0),
    2: UIColor(red: 0.7, green: 0.6, blue: 0.3, alpha: 1.0),
    3: UIColor(red: 0.75, green: 0.3, blue: 0.3, alpha: 1.0),
    4: UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0),
    5: UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1.0),
    404: UIColor(red:0.63, green: 0.63, blue: 0.63, alpha: 0.63)
]

let polutionLevelLabels: [Int:String] = [
    0: "Very Good!",
    1: "Good",
    2: "Moderate",
    3: "Unhealthy",
    4: "Very Unhealthy",
    5: "Hazardous",
    404: "No Data"
]



