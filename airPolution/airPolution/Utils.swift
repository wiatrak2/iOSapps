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
    
    init() {
        self.stationName = "NO DATA"
        self.stationId = nil
        self.stPolutionIndex = 404
        self.sensors = []
    }
    
    init(stationName: String, stationId: Int, stPolutionIndex: Int, sensors: [Sensor]) {
        self.stationName = stationName
        self.stationId = stationId
        self.stPolutionIndex = stPolutionIndex
        self.sensors = sensors
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


