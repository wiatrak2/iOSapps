//
//  ViewController.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 05.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLabel.layer.borderWidth = 2
        buttonLabel.layer.borderColor = UIColor.white.cgColor
        placeTextField.delegate = self
    }
    

    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonLabel.setTitle("Add " + textField.text!, for: .normal)
    }
    //MARK: Actions
    @IBAction func addPlaceButton(_ sender: UIButton) {
        print("addPlace button clicked")
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        addVC.placeName = placeTextField.text!
        placeTextField.text = ""
        buttonLabel.setTitle("Add", for: .normal)
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func showPlacesButton(_ sender: UIButton) {
        print("showPlaces button clicked")
    }
}

