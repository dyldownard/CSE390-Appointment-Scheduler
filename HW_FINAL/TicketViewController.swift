//
//  TicketViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//  SBUID : 110150888

import UIKit
import CoreData
/**
  - Author:
 Dylan Downard
 */
/// ViewController that just handles which ViewController should be shown when the TicketButton (middle nav button) is pressed.
class TicketViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //log = [id, name, type] where type is either student or faculty
    var id:String?
    var name:String?
    
    //MARK: - Main Function
    /**
     Checks if a user is logged in. If not, show notLogged. If a student is logged, StudentSubmitScene, else, FacultyApproveScene
     */
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        
        if (log==nil) {
            let vc = storyboard?.instantiateViewController(identifier: "notLoggedID")
            vc?.navigationItem.hidesBackButton = true
            self.navigationController?.setViewControllers([vc!], animated: true)
            return
        }
        
        id = log![0]
        name = log![1]
        if log![2] == "student" {
            //student
            //we need to know if the student has an appointment that is "ready"
            //if so, display it in StudentApproveID
            //else, dispaly create new ticket in
            let vc = storyboard?.instantiateViewController(identifier: "studentSubmitID") as? StudentSubmitViewController
            vc?.navigationItem.hidesBackButton = true
            self.navigationController?.setViewControllers([vc!], animated: true)
            return
        } else {
            //faculty
            //display
            
            let vc = storyboard?.instantiateViewController(identifier: "facultyCurrentTicketID") as? FacultyApproveViewController
            vc?.navigationItem.hidesBackButton = true
            self.navigationController?.setViewControllers([vc!], animated: true)
            return
        }
    }

}
