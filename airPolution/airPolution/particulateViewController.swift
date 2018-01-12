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
    
    var labels: [UILabel] { return [mainLabel, valueLabel, normLabel] }
    
    var particulateFormula: String = "particulate"
    var particulateLvl = 404
    var sensorId: Int?
    var pollutionColor: UIColor = pollutionLevelColors[404]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pollutionColor.withAlphaComponent(0.7)
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
                            self.valueLabel.text = self.particulateFormula + " pollution value:\n" + String(v)
                        })
                        break
                    }
                }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func initLabels() {
        self.buttonOutlet.layer.cornerRadius = 20
        self.buttonOutlet.setTitleColor(pollutionColor, for: .normal)
        for label in labels {
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.1
            label.numberOfLines = 0
            label.backgroundColor = pollutionColor
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 20
        }
    }
}
