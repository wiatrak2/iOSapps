//
//  Place.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit
import os.log

class Place: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var placeDescription: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("places")
    
    //MARK: Methods
    
    init?(name: String, photo: UIImage?, placeDescription: String?) {
        
        if(name.isEmpty) {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.placeDescription = placeDescription
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(placeDescription, forKey: PropertyKey.placeDescription)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Place object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let placeDescription = aDecoder.decodeObject(forKey: PropertyKey.placeDescription) as? String
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, placeDescription: placeDescription)
        
    }
}
