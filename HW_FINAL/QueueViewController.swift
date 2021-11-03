//
//  QueueViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//  SBUID : 110150888

import UIKit
import CoreData

/**
 struct that contains both a Reservation and an integer, for easing a sort later on
 */
struct prioTick {
    let ticket: Reservation
    let prio: Int?
}
/**
  - Author:
 Dylan Downard
 */
/// ViewController responsible for maintaining the table of tickets that a logged-in user has. Takes sort setting from QueueSettingsViewController and sorts the table based on it. Allows users to delete (or accept) tickets.
class QueueViewController: UITableViewController, DataEnteredDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //log = [id, name, type] where type is either student or faculty
    var id:String?
    var name:String?
    var type:Bool?
    
    
    var tickets:[Reservation]?
    var mode:Bool?
    
    var passBack:String = ""
    
    // MARK: - Main Function
    /**
     Makes sure there is a user logged in, fetches data
     */
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        
        if (log==nil) {
            let vc = storyboard?.instantiateViewController(identifier: "notLoggedQueueID") as? NotLoggedQueueViewController
            vc?.navigationItem.hidesBackButton = true
            self.navigationController?.setViewControllers([vc!], animated: true)
            return
        }
        if log![0] != id {
            passBack = ""
        }
        id = log![0]
        name = log![1]
        if log![2] == "student" {
            mode = false
        }else {
            mode = true
        }
        
        fetchData()
    }
    
    // MARK: - Data Population
    /**
     Populates the tickets arrray based on the sort specifier and which type of user is logged in. After fetching the data, reloads the table.
     */
    func fetchData() {
        do {
            if mode == false {// TODO implement sort from settings here
                let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred = NSPredicate(format: "student_id = %@", id!)
                if passBack == "id" {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.faculty_id), ascending: true)
                    request.sortDescriptors = [sort]
                    request.predicate = pred
                    try tickets = context.fetch(request)
                }else if passBack == "name" {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.faculty_name), ascending: true)
                    request.sortDescriptors = [sort]
                    request.predicate = pred
                    try tickets = context.fetch(request)
                } else if passBack == "prio" {
                    request.predicate = pred
                    try tickets = context.fetch(request)
                    var prios:[prioTick] = []
                    
                    for tick in tickets! {
                        var howMany = 0
                        let queueInFront:[Reservation]?
                        let queueReq = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                        let queuePred = NSPredicate(format: "faculty_id = %@", tick.faculty_id!)
                        let sort = NSSortDescriptor(key: #keyPath(Reservation.date_created), ascending: true)
                        queueReq.predicate = queuePred
                        queueReq.sortDescriptors = [sort]
                        try queueInFront = context.fetch(queueReq)
                        
                        for queueTick in queueInFront! {
                            if (queueTick.student_id == tick.student_id) {
                                break
                            }
                            howMany = howMany + 1
                        }
                        prios.append(prioTick(ticket: tick, prio: howMany))
                    }
                    prios.sort(by: { $0.prio! < $1.prio!})
                    tickets = []
                    for tick in prios {
                        tickets?.append(tick.ticket)
                    }
                }else {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.date_created), ascending: true)
                    request.sortDescriptors = [sort]
                    request.predicate = pred
                    try tickets = context.fetch(request)
                }
                
            }else {
                let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
                let pred = NSPredicate(format: "faculty_id = %@", id!)
                if passBack == "id" {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.student_id), ascending: true)
                    request.sortDescriptors = [sort]
                }else if passBack == "name" {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.student_name), ascending: true)
                    request.sortDescriptors = [sort]
                }else {
                    let sort = NSSortDescriptor(key: #keyPath(Reservation.date_created), ascending: true)
                    request.sortDescriptors = [sort]
                }
                request.predicate = pred
                try tickets = context.fetch(request)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {}
    }

    // MARK: - Table Functions

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tickets?.count ?? 0
    }
    
    /**
     Populates the table with cells specific to the type of user logged in. Students will see a number on the right of each cell denoting their position in that teacher's queue
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "queueCell")
        }
        
        if (self.mode == false) {
            let ticket = self.tickets![indexPath.row]
            
            cell.textLabel?.text = ticket.faculty_name
            cell.detailTextLabel?.text = ticket.status
            
            // figure out how many tickets there are in front of you for this professor...
            let queueInfront:[Reservation]?
            let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
            let pred = NSPredicate(format: "faculty_id = %@", ticket.faculty_id!)
            let sort = NSSortDescriptor(key: #keyPath(Reservation.date_created), ascending: true)
            request.predicate = pred
            request.sortDescriptors = [sort]
            do {
                try queueInfront = context.fetch(request)
                var pos = 0
                for tick in queueInfront! {
                    if tick.student_id == self.id && tick.status == "ready" {
                        pos = 0
                        break
                    }
                    if tick.student_id == self.id {
                        break
                    }
                    pos = pos + 1
                }
                
                let label = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
                if (pos == 0) {
                    if ticket.status == "ready" {
                        label.text = "Ready!"
                    }else {
                        label.text = "You're next"
                    }
                    
                }else {
                    label.text = "Position: \(pos)"
                }
                label.textAlignment = NSTextAlignment.right
                cell.accessoryView = label
            } catch {}
            
        }else {
            //faculty
            let ticket = self.tickets![indexPath.row]
            
            cell.textLabel?.text = ticket.student_name
            cell.detailTextLabel?.text = ticket.status
            let label = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
            label.text = "Position: \(indexPath.row)"
            label.textAlignment = NSTextAlignment.right
            cell.accessoryView = label
            
        }
        
        return cell
    }
    
    /**
     Sets up the swipe action on the cells. If the user is a student, cells that are "Ready" are not given the cancel action, but instead an accept action.
     */
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if mode == false && self.tickets![indexPath.row].status == "ready" {
            let action = UIContextualAction(style: .normal, title: "Accept") {
                (action, view, completionHandler) in
                let toRemove = self.tickets![indexPath.row]
                self.context.delete(toRemove)
                do {
                    try self.context.save()
                } catch {}
                self.fetchData()
            }
            action.backgroundColor = UIColor.orange
            return UISwipeActionsConfiguration(actions: [action])
        }else {
            let action = UIContextualAction(style: .destructive, title: "Cancel") {
                (action, view, completionHandler) in
                let toRemove = self.tickets![indexPath.row]
                self.context.delete(toRemove)
                do {
                    try self.context.save()
                } catch {}
                self.fetchData()
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
        
        
    }
    
    //MARK: - Helper Functions
    /**
     Sets up the segue to the settings controller, allowing passBack to be filled with sort type.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let secondViewController = segue.destination as! QueueSettingsViewController
            secondViewController.delegate = self
            secondViewController.choice = passBack
        }
    }
    /**
     protocol method to get data back
     */
    func userDidEnterInformation(info: String) {
        self.passBack = info
    }
    
}
