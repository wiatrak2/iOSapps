//
//  Sensor.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 11.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct Sensor : Decodable {
    let id: Int?
    let stationId: Int?
    let param: Param?
}

struct Param : Decodable {
    let paramName: String?
    let paramFormula: String?
    let paramCode: String?
    let idParam: Int?
}

func getSensor(sensorId: Int) -> [Sensor]? {
    let stationsUrl = "http://api.gios.gov.pl/pjp-api/rest/station/sensors/" + String(sensorId)

    guard let url = URL(string: stationsUrl) else { return nil }
    var sensors: [Sensor]?
    URLSession.shared.dataTask(with: url) {
        (data, response, err) in
        guard let data = data else { return }
        do {
            sensors = try JSONDecoder().decode([Sensor].self, from: data)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
        }.resume()
    
    return sensors
}
