//
//  ViewController.swift
//  TDPeopleStackView
//
//  Created by Dean151 on 05/01/2016.
//  Copyright (c) 2016 Dean151. All rights reserved.
//

import UIKit
import TDPeopleStackView

class ViewController: UIViewController {

    @IBOutlet weak var peopleStackView: TDPeopleStackView!
    
    let people = ["Bruce Garrett", "Ricky Tucker", "Clay Sharp", "Terry Robertson", "Caroline Martin", "Randy Patton", "Jonathan Bradley", "Mae Hernandez", "Oscar Fisher", "Jan Shaw"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We set the deleguate and data source
        peopleStackView.dataSource = self
        peopleStackView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: TDPeopleStackViewDataSource {
    func numberOfPeopleInStackView(peopleStackView: TDPeopleStackView) -> Int {
        return people.count
    }
    
    func peopleStackView(peopleStackView: TDPeopleStackView, imageAtIndex index: Int) -> UIImage? {
        guard index < 4 else {
            return nil
        }
        
        return UIImage(named: "user")
    }
    
    func peopleStackView(peopleStackView: TDPeopleStackView, placeholderTextAtIndex index: Int) -> String? {
        return people[index].componentsSeparatedByString(" ").map({ String($0.characters.prefix(1)) }).reduce("", combine: { $0 + $1 })
    }
}

extension ViewController: TDPeopleStackViewDelegate {
    func titleForButtonInPeopleStackView(peopleStackView: TDPeopleStackView) -> String? {
        return "Show more"
    }
    
    func peopleStackViewButtonPressed(button: UIButton, peopleStackView: TDPeopleStackView) {
        print("Button pressed")
    }
}
