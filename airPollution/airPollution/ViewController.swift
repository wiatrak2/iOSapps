//
//  ViewController.swift
//  airpollution
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
    @IBOutlet weak var BackButtonOutlet: UIButton!
    
    //MARK: Properties - Particulates Buttons
    @IBOutlet weak var PM25Button: UIButton!
    @IBOutlet weak var O3Button: UIButton!
    @IBOutlet weak var PM10Button: UIButton!
    @IBOutlet weak var NO2Button: UIButton!
    @IBOutlet weak var SO2Button: UIButton!
    var particulateButtons: [UIButton] { return [PM25Button, PM10Button, O3Button, NO2Button, SO2Button] }
    
    
    
    var stations: [Station] = []
    var pickerOptions: [String] = []
    var pickerValue = 0
    var clickCount = 0
    var stationData = pollutionData()
    var dataFetchEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if dataFetchEnd { return }
        checkButton.layer.cornerRadius = 20
        checkButton.layer.borderWidth = 5
        checkButton.layer.borderColor = UIColor.white.cgColor
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
        if dataFetchEnd { return }
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.horizontalConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (Bool) -> Void in
            if self.stations.count == 0 {
                let alert = UIAlertController(title: "Alert", message: "Could not load stations, try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "BACK", style: UIAlertActionStyle.default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.pickerOptions = getProvinces(stations: self.stations).sorted()
                self.buttonToPickerMode(firstLabel: self.pickerOptions[0])
                self.horizontalConstraint.constant += 50
            }
        })
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
            let alert = UIAlertController(title: "Alert", message: "Could not load stations, try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "BACK", style: UIAlertActionStyle.default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        case 1:
            pickerOptions = getStations(stations: stations, provinceName: pickerOptions[self.pickerValue]).sorted()
            self.pickerValue = min(pickerValue, pickerOptions.count - 1)
            self.checkButton.setTitle("Check air pollution in \n" + pickerOptions[pickerValue], for: .normal)
            self.pickerStation.reloadAllComponents()
            self.clickCount += 1
        default:
            self.stationData.stationName = pickerOptions[pickerValue]
            self.fetchData()
            self.buttonUpAnimation()
        }
    }
    
    @IBAction func particButton(_ sender: UIButton) {
        let particVC = storyboard?.instantiateViewController(withIdentifier: "particulateViewController") as! particulateViewController
        particVC.pollutionColor = sender.backgroundColor!
        particVC.particulateLvl = self.stationData.pollutionParticulatesLabel[prettyToFormula(label: (sender.titleLabel?.text!)!)]!
        particVC.particulateFormula = (sender.titleLabel?.text!)!
        particVC.sensorId = self.stationData.getSensorIdByFormula(formula: prettyToFormula(label: (sender.titleLabel?.text!)!))
        navigationController?.pushViewController(particVC, animated: true)
    }
    
    
    @IBAction func backToStart(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Methods
    
    func fetchData() {
        if let stationPicked = getStationByName(stations: stations, stationName: stationData.stationName) {
            self.stationData.stationId = stationPicked.id
        }
        guard let stationId = self.stationData.stationId else { setpollutionColor(pollutionIndex: 404) ; return }
        getpollutionForStation(stationId: stationId, completion: { (pollution) in
            self.stationData.stpollutionIndex = pollution
            getSensors(stationId: stationId, completion: { (sensors) in
                self.stationData.sensors = sensors
                self.stationData.getSensorsInfo()
                getpollutionIndex(stationId: stationId, completion: { (pollution) in
                    self.stationData.pollutionParticulatesIndex = pollution
                    self.stationData.getPariculatesLabel()
                    self.dataFetchEnd = true
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
                self.setpollutionColor(pollutionIndex: self.stationData.stpollutionIndex)
                self.clickCount = 3
                self.checkButton.isEnabled = false
            }
        })
    }
    
    func setpollutionColor(pollutionIndex: Int) {
        if pollutionIndex == 404 { self.checkButton.backgroundColor = pollutionLevelColors[pollutionIndex] ; backButtonInit() ; return }
        var index = 0
        var newColor = pollutionLevelColors[index]
        UIView.animate(withDuration: 0.3, animations: {
            self.checkButton.backgroundColor = newColor
            self.view.backgroundColor = newColor!.withAlphaComponent(0.7)
        }, completion: {(Bool) -> Void in
            if index == pollutionIndex { self.showPollutionLabels() ; return }
            index += 1 ; newColor = pollutionLevelColors[index]
            UIView.animate(withDuration: 0.3, animations: {
                self.checkButton.backgroundColor = newColor
                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                }, completion: {(Bool) -> Void in
                    if index == pollutionIndex { self.showPollutionLabels() ; return }
                    index += 1 ; newColor = pollutionLevelColors[index]
                    UIView.animate(withDuration: 0.3, animations: {
                        self.checkButton.backgroundColor = newColor
                        self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                    }, completion: {(Bool) -> Void in
                        if index == pollutionIndex { self.showPollutionLabels() ; return }
                        index += 1 ; newColor = pollutionLevelColors[index]
                        UIView.animate(withDuration: 0.3, animations: {
                            self.checkButton.backgroundColor = newColor
                            self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                        }, completion: {(Bool) -> Void in
                            if index == pollutionIndex { self.showPollutionLabels() ; return }
                            index += 1 ; newColor = pollutionLevelColors[index]
                            UIView.animate(withDuration: 0.3, animations: {
                                self.checkButton.backgroundColor = newColor
                                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                                }, completion: {(Bool) -> Void in
                                    if index == pollutionIndex { self.showPollutionLabels() ; return }
                                    index += 1 ; newColor = pollutionLevelColors[index]
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
    
    //MARK: Outlets managing
    
    func buttonToPickerMode(firstLabel: String) {
        self.checkButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.checkButton.titleLabel?.minimumScaleFactor = 0.1
        self.checkButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.checkButton.setTitle("Check air pollution in \n" + firstLabel, for: .normal)
        self.pickerStation.reloadAllComponents()
        self.pickerStation.isHidden = false
        self.clickCount += 1
    }
    
    func showPollutionLabels() {
        self.backButtonInit()
        self.particulateButtonInit()
        self.checkButton.layer.borderWidth = 0
        self.checkButton.setTitle("Air quality in\n " +  stationData.stationName + ":\n" + pollutionLevelLabels[self.stationData.stpollutionIndex]!, for: .normal)
        self.leftStack.isHidden = false
        self.leftLabel.constant += self.view.bounds.width
        self.rightStack.isHidden = false
        self.rightLabel.constant += self.view.bounds.width
        self.view.layoutIfNeeded()
        let labelColors = self.stationData.pollutionParticulatesLabel
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            for button in self.particulateButtons {
                let particulateFormula = prettyToFormula(label: (button.titleLabel?.text!)!)
                button.backgroundColor = pollutionLevelColors[labelColors[particulateFormula]!]
            }
        }, completion: nil)
    }
    
    func particulateButtonInit() {
        let backgroundColor = self.view.backgroundColor
        for button in particulateButtons {
            button.setTitle(prettyPartic(label: (button.titleLabel?.text!)!), for: .normal)
            button.backgroundColor = backgroundColor
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 15
        }
    }
    
    func backButtonInit() {
        self.BackButtonOutlet.setTitle("\u{21e6}BACK", for: .normal)
        self.BackButtonOutlet.backgroundColor = self.view.backgroundColor
        self.BackButtonOutlet.layer.borderWidth = 5
        self.BackButtonOutlet.layer.borderColor = self.checkButton.backgroundColor?.cgColor
        self.BackButtonOutlet.layer.cornerRadius = 15
        self.BackButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

