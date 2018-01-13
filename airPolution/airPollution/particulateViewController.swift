//
//  particulateViewController.swift
//  airpollution
//
//  Created by Wojciech Pratkowiecki on 12.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class particulateViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var normLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var learnMoreButton: UIButton!
    
    var labels: [UILabel] { return [mainLabel, valueLabel, normLabel] }
    
    var particulateFormula: String = "particulate"
    var particulateLvl = 404
    var sensorId: Int?
    var pollutionColor: UIColor = pollutionLevelColors[404]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pollutionColor
        self.initLabels()
        self.mainLabel.text = self.particulateFormula + "\npollution level:\n" + pollutionLevelLabels[particulateLvl]!
        let pollutionNorm = norms[prettyToFormula(label: self.particulateFormula)]!
        self.normLabel.text = self.particulateFormula + " pollution norm:\n" + String(describing: pollutionNorm)
        guard let sensorId = self.sensorId else { return }
            getpollution(sensorId: sensorId) { (pollution) in
                guard let values = pollution.values else { return }
                for value in values {
                    if let v = value.value {
                        DispatchQueue.main.async(execute: {
                            self.valueLabel.text = self.particulateFormula + " pollution value:\n" + String(format:"%.2f",v)
                        })
                        break
                    }
                }
        }
    }

    //MARK: Actions
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func learnMore(_ sender: Any) {
        let whoUrlString = "http://www.who.int/mediacentre/factsheets/fs313/en/"
        guard let whoUrl = URL(string: whoUrlString) else { return }
        UIApplication.shared.open(whoUrl, options: [:], completionHandler: nil)
    }
    
    //MARK: Outlets managing
    
    func initLabels() {
        self.buttonOutlet.layer.cornerRadius = 20
        self.buttonOutlet.setTitleColor(pollutionColor, for: .normal)
        self.learnMoreButton.layer.cornerRadius = 20
        self.learnMoreButton.setTitleColor(pollutionColor, for: .normal)
        for label in labels {
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.1
            label.numberOfLines = 0
            label.backgroundColor = pollutionColor
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 20
            label.layer.borderWidth = 2
            label.layer.borderColor = UIColor.white.cgColor
        }
    }
}
