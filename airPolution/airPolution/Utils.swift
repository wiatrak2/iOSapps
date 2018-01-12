//
//  Utils.swift
//  airpollution
//
//  Created by Wojciech Pratkowiecki on 12.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

let pollutionLevelColors: [Int:UIColor] = [
    0: UIColor(red: 0.4, green: 0.95, blue: 0.2, alpha: 1.0),
    1: UIColor(red: 0.5, green: 0.85, blue: 0.3, alpha: 1.0),
    2: UIColor(red: 0.7, green: 0.6, blue: 0.3, alpha: 1.0),
    3: UIColor(red: 0.75, green: 0.3, blue: 0.3, alpha: 1.0),
    4: UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0),
    5: UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1.0),
    404: UIColor(red:0.63, green: 0.63, blue: 0.63, alpha: 0.63)
]

let pollutionLevelLabels: [Int:String] = [
    0: "Very Good!",
    1: "Good",
    2: "Moderate",
    3: "Unhealthy",
    4: "Very Unhealthy",
    5: "Hazardous",
    404: "No Data"
]

let norms: [String:Double] = [
    "PM 2.5" : 25,
    "PM 10"  : 40,
    "O3"     : 100,
    "NO2"    : 40,
    "SO2"    : 50,
    "CO"     : 2000,
    
    "Particular" : -1
]

let particFormulas = [("NO2","NO₂"), ("SO2","SO₂"), ("O3","O₃")]

func prettyPartic(label:String) -> String {
    for (form, partic) in particFormulas {
        if form == label { return partic }
    }
    return label
}
func prettyToFormula(label:String) -> String {
    for (form, partic) in particFormulas {
        if partic == label { return form }
    }
    return label
}

extension String  {
    func firstLetterCapitalization() -> String {
        let firstLetter = prefix(1).capitalized
        let restOfString = dropFirst().lowercased()
        return firstLetter + restOfString
    }
    
    mutating func firstLetterCapitalization() {
        self = self.firstLetterCapitalization()
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
