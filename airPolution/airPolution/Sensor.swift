//
//  Sensor.swift
//  airpollution
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

func getSensors(stationId: Int, completion: @escaping ([Sensor])->())  {
    let sensorUrl = "http://api.gios.gov.pl/pjp-api/rest/station/sensors/" + String(stationId)
    guard let url = URL(string: sensorUrl) else { return }
    var sensors: [Sensor] = []
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            sensors = try JSONDecoder().decode([Sensor].self, from: data)
            completion(sensors)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
}
