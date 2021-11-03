//
//  StudentApproveViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//

import UIKit
import CoreData

class StudentApproveViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var id:String?
    var name:String?
    
    var tickets:[Reservation]?
    var ticket : Reservation?
    
    @IBOutlet weak var studentApproveLabel: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        
        if (log==nil) {
            let vc = storyboard?.instantiateViewController(identifier: "notLoggedID")
            vc?.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        
        id = log![0]
        name = log![1]
        
        do {
            let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
            let pred = NSPredicate(format: "student_id = %@ AND status = %@", id!, "ready")
            request.predicate = pred
            try tickets = context.fetch(request)
            
            ticket = tickets![0]
            
        } catch {
            
        }
        
    }

    @IBAction func beginAppointmentPressed(_ sender: UIButton) {
        do {
            self.context.delete(ticket!)
            try self.context.save()
        _ = navigationController?.popViewController(animated: true)
        }catch {
            
        }
    }
}
