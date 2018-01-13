//
//  DescriptionViewController.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {

    //MARK: Properties
    var placeIndex = 0
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeNameLabel.text = places[placeIndex].name
        descriptionField.text = places[placeIndex].placeDescription
        descriptionField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        places[placeIndex].placeDescription = descriptionField.text
        descriptionField.resignFirstResponder()
        savePlaces()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
