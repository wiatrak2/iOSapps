//
//  Station.swift
//  airpollution
//
//  Created by Wojciech Pratkowiecki on 11.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

struct Station : Decodable {
    let id: Int?
    let stationName: String?
    let gegrLat: String?
    let gegrLon: String?
    let city: City?
    let addressStreen: String?
}

struct City : Decodable {
    let id: Int?
    let name: String?
    let commune: Commune?
}

struct Commune : Decodable {
    let communeName: String?
    let districtName: String?
    let provinceName: String?
}

func getStations(completion: @escaping ([Station])->())  {
    let stationsUrl = "http://api.gios.gov.pl/pjp-api/rest/station/findAll"
    guard let url = URL(string: stationsUrl) else { return }
    var stations: [Station] = []
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
            stations = try JSONDecoder().decode([Station].self, from: data)
            completion(stations)
        } catch let jsonErr {
            print(jsonErr)
            return
        }
    }.resume()
    
}

func getProvinces(stations: [Station]) -> [String] {
    var provinces: Set<String> = []
    for station in stations {
        guard let city = station.city else { continue }
        guard let commune = city.commune else { continue }
        guard let province = commune.provinceName else { continue }
        let provinceCapitalizated = province.firstLetterCapitalization()
        provinces.insert(provinceCapitalizated)
    }
    return Array(provinces)
}

func getStations(stations: [Station], provinceName: String) -> [String] {
    var cities: Set<String> = []
    for station in stations {
        guard let city = station.city else { continue }
        guard let commune = city.commune else { continue }
        guard let province = commune.provinceName else { continue }
        let provinceCapitalizated = province.firstLetterCapitalization()
        if provinceName == provinceCapitalizated {
            guard let stationName = station.stationName else { continue }
            cities.insert(stationName)
        }
    }
    return Array(cities)
}

func getStationByName(stations:[Station], stationName: String) -> Station? {
    for station in stations {
        guard let currentStation = station.stationName else { continue }
        if currentStation == stationName { return station }
    }
    return nil
}
