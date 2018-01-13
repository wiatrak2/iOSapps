//
//  pollutionData.swift
//  airpollution
//
//  Created by Wojciech Pratkowiecki on 12.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct pollutionData {
    
    var stationName: String
    var stationId: Int?
    var stpollutionIndex: Int
    var sensors: [Sensor]
    var sensorInfo: [(Int, String)]
    var pollutionParticulatesIndex: pollutionLevelIndex?
    var pollutionParticulatesLabel: [String:Int]
    
    init() {
        self.stationName = "NO DATA"
        self.stationId = nil
        self.stpollutionIndex = 404
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
    
    func getSensorIdByFormula(formula: String) -> Int? {
        for (id, particFormula) in sensorInfo {
            if particFormula == formula.removingWhitespaces() { return id }
        }
        return nil
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
