//
//  ViewController.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 10.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: Properties
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLabel: NSLayoutConstraint!
    @IBOutlet weak var rightLabel: NSLayoutConstraint!
    @IBOutlet weak var leftLabelAxis: NSLayoutConstraint!
    @IBOutlet weak var rightLabelAxis: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    @IBOutlet weak var pickerStation: UIPickerView!
    
    var stations: [Station] = []
    var pickerOptions: [String] = []
    var pickerValue = 0
    var clickCount = 0
    var stationData = pollutionData()
    var dataFetchEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton.layer.cornerRadius = 20
        horizontalConstraint.constant -= view.bounds.height
        leftLabel.constant -= view.bounds.width
        rightLabel.constant -= view.bounds.width
        leftLabelAxis.constant = self.view.bounds.width * 0.5 + 3
        rightLabelAxis.constant = self.view.bounds.width * 0.5 + 3

        pickerStation.isHidden = true
        pickerStation.delegate = self
        pickerStation.dataSource = self
        
        leftStack.isHidden = true
        rightStack.isHidden = true
        getStations(completion: {newStations in
            self.stations = newStations
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.horizontalConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.checkButton.setTitle("Check air pollution in \n" + pickerOptions[row], for: .normal)
        self.pickerValue = row
    }
    
    //MARK: Actions
    @IBAction func checkPoluitonButton(_ sender: Any) {
        
        switch self.clickCount {
        case 0:
            if self.stations.count == 0 {
                let alert = UIAlertController(title: "Alert", message: "No stations loaded, try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                pickerOptions = getProvinces(stations: self.stations).sorted()
                self.buttonToPickerMode(firstLabel: pickerOptions[0])
                self.horizontalConstraint.constant += 50
            }
        case 1:
            pickerOptions = getStations(stations: stations, provinceName: pickerOptions[self.pickerValue]).sorted()
            self.checkButton.setTitle("Check air pollution in \n" + pickerOptions[0], for: .normal)
            self.pickerStation.reloadAllComponents()
            self.clickCount += 1
        default:
            self.stationData.stationName = pickerOptions[pickerValue]
            self.fetchData()
            self.buttonUpAnimation()
        }
    }
    
    func fetchData() {
        if let stationPicked = getStationByName(stations: stations, stationName: stationData.stationName) {
            self.stationData.stationId = stationPicked.id
        }
        guard let stationId = self.stationData.stationId else { setPolutionColor(polutionIndex: 404) ; return }
        getPolutionForStation(stationId: stationId, completion: { (pollution) in
            self.stationData.stPolutionIndex = pollution
            getSensors(stationId: stationId, completion: { (sensors) in
                self.stationData.sensors = sensors
                self.stationData.getSensorsInfo()
                getPolutionIndex(stationId: stationId, completion: { (pollution) in
                    self.stationData.pollutionParticulatesIndex = pollution
                    self.stationData.getPariculatesLabel()
                    self.dataFetchEnd = true
                    print("STATION DATA\n") // DEBUG
                    print(self.stationData)
                    print("____")
                    print(self.stationData.pollutionParticulatesLabel)
                })
            })
        })
    }
        
    func buttonUpAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.horizontalConstraint.constant -= 50
            self.horizontalConstraint.constant = -0.5 * self.checkButton.frame.size.width + 20
            if self.clickCount < 3 {
                self.pickerStation.isHidden = true
                self.view.layoutIfNeeded()
            }
        }, completion: { (_:Bool) in
            if self.clickCount < 3 {
                self.setPolutionColor(polutionIndex: self.stationData.stPolutionIndex)
                self.clickCount = 3
            }
        })
    }
    
    func setPolutionColor(polutionIndex: Int) {
        self.checkButton.setTitle("Air quality in\n " +  stationData.stationName + ":\n" + polutionLevelLabels[polutionIndex]!, for: .normal)
        if polutionIndex == 404 { self.checkButton.backgroundColor = polutionLevelColors[polutionIndex] ; return }
        var index = 0
        var newColor = polutionLevelColors[index]
        UIView.animate(withDuration: 0.3, animations: {
            self.checkButton.backgroundColor = newColor
            self.view.backgroundColor = newColor!.withAlphaComponent(0.7)
        }, completion: {(Bool) -> Void in
            if index == polutionIndex { self.showPollutionLabels() ; return }
            index += 1 ; newColor = polutionLevelColors[index]
            UIView.animate(withDuration: 0.3, animations: {
                self.checkButton.backgroundColor = newColor
                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                }, completion: {(Bool) -> Void in
                    if index == polutionIndex { self.showPollutionLabels() ; return }
                    index += 1 ; newColor = polutionLevelColors[index]
                    UIView.animate(withDuration: 0.3, animations: {
                        self.checkButton.backgroundColor = newColor
                        self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                    }, completion: {(Bool) -> Void in
                        if index == polutionIndex { self.showPollutionLabels() ; return }
                        index += 1 ; newColor = polutionLevelColors[index]
                        UIView.animate(withDuration: 0.3, animations: {
                            self.checkButton.backgroundColor = newColor
                            self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                        }, completion: {(Bool) -> Void in
                            if index == polutionIndex { self.showPollutionLabels() ; return }
                            index += 1 ; newColor = polutionLevelColors[index]
                            UIView.animate(withDuration: 0.3, animations: {
                                self.checkButton.backgroundColor = newColor
                                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                                }, completion: {(Bool) -> Void in
                                    if index == polutionIndex { self.showPollutionLabels() ; return }
                                    index += 1 ; newColor = polutionLevelColors[index]
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.checkButton.backgroundColor = newColor
                                        self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                                    }, completion: { (Bool) ->Void in
                                        self.showPollutionLabels() ; return
                            })
                        })
                    })
                })
            })
        })
    }
    

    
    func showPollutionLabels() {
       // UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.leftStack.isHidden = false
            self.leftLabel.constant += self.view.bounds.width
            self.rightStack.isHidden = false
            self.rightLabel.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        //}, completion: nil)
        
    }
    
    func buttonToPickerMode(firstLabel: String) {
        self.checkButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.checkButton.titleLabel?.minimumScaleFactor = 0.1
        self.checkButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.checkButton.setTitle("Check air pollution in \n" + firstLabel, for: .normal)
        self.pickerStation.reloadAllComponents()
        self.pickerStation.isHidden = false
        self.clickCount += 1
    }
}

