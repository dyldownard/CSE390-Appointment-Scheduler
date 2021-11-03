//
//  NotLoggedQueueViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/24/21.
//  SBUID : 110150888

import UIKit
/**
  - Author:
 Dylan Downard
 */
///View Controller for "NotLoggedQueue", a view that displays that there is no user logged in
class NotLoggedQueueViewController: UIViewController {
    
    /**
        Every time this view appears, we want it to check if it should appear. If not, then redirect the navigation's rootviewcontroller to the proper one
        - Parameters:
            - animated: whether or not the view in question is animated when opened
     */
    override func viewDidAppear(_ animated: Bool) {
        //set up user information
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        
        //if there is no user, this is the correct view
        if (log == nil) {
            return
        }
        
        //however if there is a user, and the user's info isn't blank, jump back to the correct view
        if (log![0] != "") {
            let vc = storyboard?.instantiateViewController(identifier: "queueViewID") as! QueueViewController
            navigationController?.setViewControllers([vc], animated: true)
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
    }

}
