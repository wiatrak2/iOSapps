//
//  EditDescViewController.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class EditDescViewController: UIViewController {

    //MARK: Properties
    var placeIndex = 0
    @IBOutlet weak var newDescText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, self]
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButton(_ sender: UIButton) {
        places[placeIndex].placeDescription = newDescText.text
        newDescText.text = ""
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
