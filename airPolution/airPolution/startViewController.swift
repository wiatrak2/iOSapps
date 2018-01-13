//
//  startViewController.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 13.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class startViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.horizontalConstraint.constant -= self.view.bounds.height
        self.startButton.layer.cornerRadius = 20
        self.startButton.layer.borderWidth = 5
        self.startButton.layer.borderColor = UIColor.white.cgColor
        self.view.backgroundColor = self.startButton.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.horizontalConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func startClick(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.horizontalConstraint.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (Bool) -> Void in
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(mainVC, animated: true)
        })
    }
}
