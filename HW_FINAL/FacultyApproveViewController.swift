//
//  FacultyApproveViewController.swift
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
/// View Controller that handles the Faculty's Appointment Approval view. Faculty are able to see the next non-readied appointment and set it to ready. Refreshes every 5 seconds when there is no appointment available (for this usage it is impossible for one to appear however)
class FacultyApproveViewController: UIViewController {
    
    //context for queries
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //information of user to be stored for convenience
    var id:String?
    var name:String?
    
    //collection of appointments
    var tickets:[Reservation]?
    
    // MARK: - UIElements
    @IBOutlet weak var apptTitle: UILabel!
    @IBOutlet weak var loadingThing: UIActivityIndicatorView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var aptButton: UIButton!
    
    
    // MARK: - Main Functions
    /**
     Every time this view loads, we want to make sure it should be allowed to load, and then if it should, we send to loadTicket() to enter the ticket loop
     
     - Parameters:
        - animated: whether or not this view is animated upon opening
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
            let vc = storyboard?.instantiateViewController(identifier: "ticketViewID") as! TicketViewController
            navigationController?.setViewControllers([vc], animated: true)
            return
        }
        
        loadTicket()
    }
    
    // MARK: - Helper Functions
    
    /**
     Attempt to load the next ticket in the faculty's queue given by id. If no such ticket is in the queue, fire lookForTickets() which may fire loadTickets(), making this a recursive loop.
     */
    @objc func loadTicket() {
        do {
            //set up the query
            let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
            let pred = NSPredicate(format: "faculty_id = %@ AND status != %@", id!, "ready")
            //sort by date
            let sort = NSSortDescriptor(key: #keyPath(Reservation.date_created), ascending: true)
            request.predicate = pred
            request.sortDescriptors = [sort]
            try tickets = context.fetch(request)
        } catch {}
        //if we have no tickets, go to check
        if tickets!.count == 0 {
            lookForTickets()
            return
        }
        //we have a ticket, display its
        apptTitle.isHidden = false
        studentName.text = "Name: \(tickets![0].student_name!)"
        studentID.text = "SID: \(tickets![0].student_id!)"
        studentName.isHidden = false
        studentID.isHidden = false
        aptButton.isHidden = false
        loadingThing.stopAnimating()
    }
    /**
     Set up the view such that the user sees that the app is attempting to locate the next ticket. When called, there is a 5 second delay before sending back to loadTicket()
     */
    @objc func lookForTickets() {
        studentID.isHidden = true
        studentName.isHidden = true
        aptButton.isHidden = true
        apptTitle.text = "Waiting for next ticket"
        apptTitle.isHidden = false
        loadingThing.startAnimating()
        loadingThing.isHidden = false
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.loadTicket), userInfo: nil, repeats: false)
    }
    
    // MARK: - Actions
    
    /**
     Mark the visible ticket as ready, and save it's status.
     */
    @IBAction func aptReady(_ sender: UIButton) {
        do {
            tickets![0].setValue("ready", forKey: "status")
            try self.context.save()
        } catch {}
        lookForTickets()
    }
}
