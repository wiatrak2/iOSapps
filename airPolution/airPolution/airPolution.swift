//
//  airPolution.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 11.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct AirPolution : Decodable {
    let key: String?
    let values: [AirPolutionValues]?
}

struct AirPolutionValues : Decodable {
    let date: String?
    let value: Double?
}

struct PolutionLevelIndex : Decodable {
    let id: Int?
    let stCalcDate: String?
    let stIndexLevel: SinglePolutionIndex?
    let stSourceDate: String?
    let so2CalcDate: String?
    let so2IndexLevel: SinglePolutionIndex?
    let so2SourceDate: String?
    let no2CalcDate: String?
    let no2IndexLevel: SinglePolutionIndex?
    let no2SourceDate: String?
    let coCalcDate: String?
    let coIndexLevel: SinglePolutionIndex?
    let coSourceDate: String?
    let pm10CalcDate: String?
    let pm10IndexLevel: SinglePolutionIndex?
    let pm10SourceDate: String?
    let pm25CalcDate: String?
    let pm25IndexLevel: SinglePolutionIndex?
    let pm25SourceDate: String?
    let o3CalcDate: String?
    let o3IndexLevel: SinglePolutionIndex?
    let o3SourceDate: String?
    let c6h6CalcDate: String?
    let c6h6IndexLevel: SinglePolutionIndex?
    let c6h6SourceDate: String?
}

struct SinglePolutionIndex : Decodable {
    let id: Int?
    let indexLevelName: String?
}

func getPolution(sensorId: Int, completion: @escaping ([AirPolution])->())  {
    let dataUrl = "http://api.gios.gov.pl/pjp-api/rest/data/getData/" + String(sensorId)
    guard let url = URL(string: dataUrl) else { return }
    var polutionData: [AirPolution] = []
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            polutionData = try JSONDecoder().decode([AirPolution].self, from: data)
            completion(polutionData)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
}

func getPolutionIndex(stationId: Int, completion: @escaping (PolutionLevelIndex)->())  {
    let indexUrl = "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/" + String(stationId)
    guard let url = URL(string: indexUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            let polutionIndex = try JSONDecoder().decode(PolutionLevelIndex?.self, from: data)
            completion(polutionIndex!)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
}
