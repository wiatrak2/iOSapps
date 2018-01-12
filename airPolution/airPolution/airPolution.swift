//
//  airpollution.swift
//  airpollution
//
//  Created by Wojciech Pratkowiecki on 11.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct Airpollution : Decodable {
    let key: String?
    let values: [AirpollutionValues]?
}

struct AirpollutionValues : Decodable {
    let date: String?
    let value: Double?
}

struct pollutionLevelIndex : Decodable {
    let id: Int?
    let stCalcDate: String?
    let stIndexLevel: SinglepollutionIndex?
    let stSourceDate: String?
    let so2CalcDate: String?
    let so2IndexLevel: SinglepollutionIndex?
    let so2SourceDate: String?
    let no2CalcDate: String?
    let no2IndexLevel: SinglepollutionIndex?
    let no2SourceDate: String?
    let coCalcDate: String?
    let coIndexLevel: SinglepollutionIndex?
    let coSourceDate: String?
    let pm10CalcDate: String?
    let pm10IndexLevel: SinglepollutionIndex?
    let pm10SourceDate: String?
    let pm25CalcDate: String?
    let pm25IndexLevel: SinglepollutionIndex?
    let pm25SourceDate: String?
    let o3CalcDate: String?
    let o3IndexLevel: SinglepollutionIndex?
    let o3SourceDate: String?
    let c6h6CalcDate: String?
    let c6h6IndexLevel: SinglepollutionIndex?
    let c6h6SourceDate: String?
}

struct SinglepollutionIndex : Decodable {
    let id: Int?
    let indexLevelName: String?
}

func getpollution(sensorId: Int, completion: @escaping (Airpollution)->())  {
    let dataUrl = "http://api.gios.gov.pl/pjp-api/rest/data/getData/" + String(sensorId)
    guard let url = URL(string: dataUrl) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            let pollutionData = try JSONDecoder().decode(Airpollution.self, from: data)
            completion(pollutionData)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
}

func getpollutionIndex(stationId: Int, completion: @escaping (pollutionLevelIndex)->())  {
    let indexUrl = "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/" + String(stationId)
    guard let url = URL(string: indexUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            let pollutionIndex = try JSONDecoder().decode(pollutionLevelIndex?.self, from: data)
            completion(pollutionIndex!)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
}

func getpollutionForStation(stationId: Int, completion: @escaping (Int)->()) {
    getpollutionIndex(stationId: stationId, completion: { (pollution) in
        guard let stationLevel = pollution.stIndexLevel else { return }
        guard let pollutionLevel = stationLevel.id else { return }
        completion(pollutionLevel)
    })
}
