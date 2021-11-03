//
//  UserViewController.swift
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
/// View Controller responsible for showing a user their information, as well as how many appointments they have pending or ready.
class UserViewController: UIViewController {
    //context for queries
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //tickets to be considered
    var tickets:[Reservation]?
    
    //log = [id, name, type] where type is either student or faculty
    var id:String?
    var name:String?
    var type:Bool?
    
    // MARK: - UIElements
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loadingThing: UIActivityIndicatorView!
    
    // MARK: - Main Functions
    /**
     Every time thsi view loads, check if a user is logged in. If not, display the login screen.  When setting up the user screen, fetch the reservations that belong to this user and display the ready and non-ready amounts.
     */
    override func viewDidAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        
        if (log==nil) {
            let vc = storyboard?.instantiateViewController(identifier: "loginID") as? LoginViewController
            self.navigationController?.setViewControllers([vc!], animated: true)
            return
        }
        id = log![0]
        name = log![1]
        if log![2] == "student" {
            type = false;
            do {
                let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred = NSPredicate(format: "student_id = %@ AND status != %@", id!, "ready")
                request.predicate = pred
                try tickets = context.fetch(request)
                
                pendingLabel.text = "You have \(tickets!.count) pending appointments"
                
                let request2 = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred2 = NSPredicate(format: "student_id = %@ AND status = %@", id!, "ready")
                request2.predicate = pred2
                try tickets = context.fetch(request2)
                
                readyLabel.text = "You have \(tickets!.count) ready appointments"
            } catch {}
        }else {
            type = true;
            do {
                let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred = NSPredicate(format: "faculty_id = %@ AND status != %@", id!, "ready")
                request.predicate = pred
                try tickets = context.fetch(request)
                
                pendingLabel.text = "You have \(tickets!.count) pending appointments"
                
                let request2 = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred2 = NSPredicate(format: "faculty_id = %@ AND status = %@", id!, "ready")
                request2.predicate = pred2
                try tickets = context.fetch(request2)
                
                readyLabel.text = "You have \(tickets!.count) ready appointments"
            } catch {}
        }
        welcomeLabel.text = "Welcome \(name ?? "Idk who you are")"
        welcomeLabel.isHidden = false
        readyLabel.isHidden = false
        pendingLabel.isHidden = false
        logoutButton.isHidden = false
        loadingThing.stopAnimating()
    }
    
    // MARK: - Actions
    /*
     When the logout button is pressed, remove userdata and go to login screen.
     */
    @IBAction func logoutPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userLog")
        let vc = storyboard?.instantiateViewController(identifier: "loginID") as? LoginViewController
        self.navigationController?.setViewControllers([vc!], animated: true)
    }
    
}
