//
//  NotLoggedViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//  SBUID : 110150888

import UIKit
/**
  - Author:
 Dylan Downard
 */
///View Controller for "NotLogged", a view that displays that there is no user logged in
class NotLoggedViewController: UIViewController {

    /**
        Every time this view appears, we want it to check if it should appear. If not, then redirect the navigation's rootviewcontroller to the proper one
        - Parameters:
            - animated: whether or not the view in question is animated when opened
     */
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        //set up user information
        if (log == nil) {
            return
        }
        //if there is no user, this is the correct view
        if (log![0] != "") {
            let vc = storyboard?.instantiateViewController(identifier: "ticketViewID") as! TicketViewController
            navigationController?.setViewControllers([vc], animated: true)
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
    }
    


}
