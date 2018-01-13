//
//  data.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit
import os.log

//MARK: Types
var firstLoad = true
var places = [Place]()

struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let placeDescription = "placeDescription"
}

func savePlaces() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(places, toFile: Place.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Places successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save places", log: OSLog.default, type: .error)
    }
}



