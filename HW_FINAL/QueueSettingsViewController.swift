//
//  QueueSettingsViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
// SBUID : 110150888

import UIKit

/**
 Protocol that  allows a string to be sent back to QueueViewController
 */
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}
/**
  - Author:
 Dylan Downard
 */
/// View Controller that manages (albiet sloppily) the Queue Settings. Makes sure that only 1 switch is allowed to be in the "on" state at a time so that only 1 sort can be active. This has been a self-chosen restriction, as it is fully possible to set a request's sortDescriptors to multiple sorts. The active switch is made uninteractable so that always 1 and only 1 switches are on.
class QueueSettingsViewController: UIViewController {
    
    //sets delegate from QueueViewController
    weak var delegate: DataEnteredDelegate? = nil
    var choice:String = ""
    // MARK: - UIElementss
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var idSwitch: UISwitch!
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var prioritySwitch: UISwitch!
    @IBOutlet weak var prioLabel: UILabel!
    
   
    // MARK: - Main Functions
    /**
     When the view loads, it is given a "choice" string from QueueViewController. With this, it decides which switch should be active by default.
     */
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]

        if log![2] == "student" {
            prioritySwitch.isHidden = false
            prioLabel.isHidden = false
        }else {
            prioritySwitch.isHidden = true
            prioLabel.isHidden = true
            if choice == "prio" {
                choice = ""
            }
        }
        
        if choice == "" {
            defaultSwitch.setOn(true, animated: false)
            defaultSwitch.isUserInteractionEnabled = false
            idSwitch.setOn(false, animated: false)
            idSwitch.isUserInteractionEnabled = true
            nameSwitch.setOn(false, animated: false)
            nameSwitch.isUserInteractionEnabled = true
            prioritySwitch.setOn(false, animated: false)
            prioritySwitch.isUserInteractionEnabled = true
        }else if choice == "id" {
            defaultSwitch.setOn(false, animated: false)
            defaultSwitch.isUserInteractionEnabled = true
            idSwitch.setOn(true, animated: false)
            idSwitch.isUserInteractionEnabled = false
            nameSwitch.setOn(false, animated: false)
            nameSwitch.isUserInteractionEnabled = true
            prioritySwitch.setOn(false, animated: false)
            prioritySwitch.isUserInteractionEnabled = true
        }else if choice == "name" {
            defaultSwitch.setOn(false, animated: false)
            defaultSwitch.isUserInteractionEnabled = true
            idSwitch.setOn(false, animated: false)
            idSwitch.isUserInteractionEnabled = true
            nameSwitch.setOn(true, animated: false)
            nameSwitch.isUserInteractionEnabled = false
            prioritySwitch.setOn(false, animated: false)
            prioritySwitch.isUserInteractionEnabled = true
        }else {
            defaultSwitch.setOn(false, animated: false)
            defaultSwitch.isUserInteractionEnabled = true
            idSwitch.setOn(false, animated: false)
            idSwitch.isUserInteractionEnabled = true
            nameSwitch.setOn(false, animated: false)
            nameSwitch.isUserInteractionEnabled = true
            prioritySwitch.setOn(true, animated: false)
            prioritySwitch.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Actions
    /**
     Swaps the choice to be the default sort, sorts out switches
     */
    @IBAction func defaultPressed(_ sender: Any) {
        choice = ""
        defaultSwitch.isUserInteractionEnabled = false
        idSwitch.setOn(false, animated: true)
        idSwitch.isUserInteractionEnabled = true
        nameSwitch.setOn(false, animated: true)
        nameSwitch.isUserInteractionEnabled = true
        prioritySwitch.setOn(false, animated: true)
        prioritySwitch.isUserInteractionEnabled = true
    }
    /**
     Swaps the choice to be the id sort, sorts out switches
     */
    @IBAction func idPressed(_ sender: Any) {
        choice = "id"
        idSwitch.isUserInteractionEnabled = false
        defaultSwitch.setOn(false, animated: true)
        defaultSwitch.isUserInteractionEnabled = true
        nameSwitch.setOn(false, animated: true)
        nameSwitch.isUserInteractionEnabled = true
        prioritySwitch.setOn(false, animated: true)
        prioritySwitch.isUserInteractionEnabled = true
    }
    /**
     Swaps the choice to be the name sort, sorts out switches
     */
    @IBAction func namePressed(_ sender: Any) {
        choice = "name"
        nameSwitch.isUserInteractionEnabled = false
        defaultSwitch.setOn(false, animated: true)
        defaultSwitch.isUserInteractionEnabled = true
        idSwitch.setOn(false, animated: true)
        idSwitch.isUserInteractionEnabled = true
        prioritySwitch.setOn(false, animated: true)
        prioritySwitch.isUserInteractionEnabled = true
    }
    /**
     Swaps the choice to be the priority sort, sorts out switches
     */
    @IBAction func priorityPressed(_ sender: Any) {
        choice = "prio"
        prioritySwitch.isUserInteractionEnabled = false
        defaultSwitch.setOn(false, animated: true)
        defaultSwitch.isUserInteractionEnabled = true
        idSwitch.setOn(false, animated: true)
        idSwitch.isUserInteractionEnabled = true
        nameSwitch.setOn(false, animated: true)
        nameSwitch.isUserInteractionEnabled = true
    }
    
    // MARK: - Helper Functions
    /**
     Sends string back to QueueViewController to let it know which sort it should be performing.
     */
    override func viewWillDisappear(_ animated: Bool) {
        print("Hello")
        delegate?.userDidEnterInformation(info: choice)
        //if the back button wasn't pressed but instead a nav button was pressed, we want settings to be closed when we go back to queue
        _ = navigationController?.popViewController(animated: false)
    }

}
