//
//  ViewController.swift
//  airPolution
//
//  Created by Wojciech Pratkowiecki on 10.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLabel: NSLayoutConstraint!
    @IBOutlet weak var rightLabel: NSLayoutConstraint!
    @IBOutlet weak var leftLabelAxis: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    
    var stations: [Station] = []
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton.layer.cornerRadius = 20
        
        horizontalConstraint.constant -= view.bounds.height
        leftLabel.constant += view.bounds.width
        rightLabel.constant += view.bounds.width
        leftLabelAxis.constant = self.view.bounds.width * 0.5
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

    //MARK: Actions
    @IBAction func checkPoluitonButton(_ sender: Any) {
        let provinces = getProvinces(stations: self.stations).sorted()
        print(getCities(stations: stations, provinceName: provinces[0]))
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            print(self.view.bounds.height)
            self.horizontalConstraint.constant = -0.5 * self.checkButton.frame.size.width + 20
            print(self.checkButton.backgroundColor!)
            //setPolutionColor(polutionIndex: 2, colorObject: &self.checkButton.backgroundColor!)
            if self.firstLoad {
                self.leftStack.isHidden = false
                self.rightStack.isHidden = false
                self.leftLabel.constant -= self.view.bounds.width
                self.rightLabel.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                self.firstLoad = false
            }
        }, completion: { (finished:Bool) in
            self.setPolutionColor(polutionIndex: 6)
        })
    }
    
    func setPolutionColor(polutionIndex: Int) {
        var index = 1
        var newColor = polutionLevelColors[index]
        UIView.animate(withDuration: 0.3, animations: {
            self.checkButton.backgroundColor = newColor
            self.view.backgroundColor = newColor!.withAlphaComponent(0.7)
        }, completion: {(Bool) -> Void in
            if index == polutionIndex { return }
            index += 1 ; newColor = polutionLevelColors[index]
            UIView.animate(withDuration: 0.3, animations: {
                self.checkButton.backgroundColor = newColor
                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                }, completion: {(Bool) -> Void in
                    if index == polutionIndex { return }
                    index += 1 ; newColor = polutionLevelColors[index]
                    UIView.animate(withDuration: 0.3, animations: {
                        self.checkButton.backgroundColor = newColor
                        self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                    }, completion: {(Bool) -> Void in
                        if index == polutionIndex { return }
                        index += 1 ; newColor = polutionLevelColors[index]
                        UIView.animate(withDuration: 0.3, animations: {
                            self.checkButton.backgroundColor = newColor
                            self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                        }, completion: {(Bool) -> Void in
                            if index == polutionIndex { return }
                            index += 1 ; newColor = polutionLevelColors[index]
                            UIView.animate(withDuration: 0.3, animations: {
                                self.checkButton.backgroundColor = newColor
                                self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                                }, completion: {(Bool) -> Void in
                                    if index == polutionIndex { return }
                                    index += 1 ; newColor = polutionLevelColors[index]
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.checkButton.backgroundColor = newColor
                                        self.view.backgroundColor = newColor?.withAlphaComponent(0.7)
                                    }, completion: nil)
                        })
                    })
                })
            })
        })
    }
}

