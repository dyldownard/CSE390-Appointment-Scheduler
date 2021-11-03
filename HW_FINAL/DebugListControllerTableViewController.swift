//
//  DebugListControllerTableViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//  SBUID : 110150888

import UIKit
/**
  - Author:
 Dylan Downard
 */
/// This view controller manages the implemented debug view that allows users (testers for grading) of the app to view all lists maintained by CoreData, view data from each item, and delete if need be. Items cannot be created by this view, only viewed and deleted.
class DebugListControllerTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var students:[Student]?
    var faculty:[Faculty]?
    var tickets:[Reservation]?
    var mode:Int = 0
    
    // MARK: - Main Function
    /**
     On view open, request to populate the lists' data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Data Population
    /**
     Populates the data depending on what mode the top selector is in (Student, Faculty, Ticket) so that  we are not fetching unrequired materials. After fetch, repopulates the table in view.
     */
    func fetchData() {
        do {
            if mode == 0 {
                self.students = try context.fetch(Student.fetchRequest())
            }else if mode == 1{
                self.faculty = try context.fetch(Faculty.fetchRequest())
            } else {
                self.tickets = try context.fetch(Reservation.fetchRequest())
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    // MARK: - Table Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /**
     Function gives the number of rows dependent on which mode/table we're currently looking at
     - Returns: number of rows that should be currently displayed
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == 0 {
            return self.students?.count ?? 0
        }else if mode == 1{
            return self.faculty?.count ?? 0
        }else {
            return self.tickets?.count ?? 0
        }
    }


    /**
     Creates cells for the various different elements in the table. Type of cell created depends on which mode the view is in.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "debugCell", for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "debugCell")
        }
        
        if (self.mode == 0) {
            let student = self.students![indexPath.row]
            
            cell.textLabel?.text = student.name
            cell.detailTextLabel?.text = student.password
            
            let label = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
            label.text = "ID: \(student.id!)"
            label.textAlignment = NSTextAlignment.right
            cell.accessoryView = label
        }else if (self.mode == 1) {
            let facult = self.faculty![indexPath.row]
            
            cell.textLabel?.text = facult.name
            cell.detailTextLabel?.text = facult.password
            
            let label = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
            label.text = "ID: \(facult.id!)"
            label.textAlignment = NSTextAlignment.right
            cell.accessoryView = label
        }else {
            let ticket = self.tickets![indexPath.row]
            
            cell.textLabel?.text = "Faculty: \(ticket.faculty_name!)"
            cell.detailTextLabel?.text = "Student: \(ticket.student_name!)"
            
            let label = UILabel.init(frame: CGRect(x:0, y:0, width:150, height:20))
            label.text = "Status: \(ticket.status!)"
            label.textAlignment = NSTextAlignment.right
            cell.accessoryView = label
        }
        

        return cell
    }
    
    /**
     Sets up the swiping action on each of the cells.  Keeps in mind that the current user that is logged in (if there is one) should not be deleted. The sliding action on this logged user shows that they are not allowed to delete it.
     */
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults = UserDefaults.standard
        let log = defaults.object(forKey: "userLog") as? [String]
        if (log != nil) {
            if (mode == 0) && (log![0] == self.students![indexPath.row].id) {
                let action = UIContextualAction(style: .normal, title: "Logged In") { (action, view, completionHandler) in}
                action.backgroundColor = UIColor.systemBlue
                return UISwipeActionsConfiguration(actions: [action])
            }
            if (mode == 1) && (log![0] == self.faculty![indexPath.row].id) {
                let action = UIContextualAction(style: .normal, title: "Logged In") { (action, view, completionHandler) in}
                action.backgroundColor = UIColor.systemBlue
                return UISwipeActionsConfiguration(actions: [action])
            }
        }
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let defaults = UserDefaults.standard
            let log = defaults.object(forKey: "userLog") as? [String]
            if (self.mode == 0) {
                if (log != nil) && (log![0] == self.students![indexPath.row].id) {
                    return
                }
                let toRemove = self.students![indexPath.row]
                self.context.delete(toRemove)
                do {
                    try self.context.save()
                } catch {}
                self.fetchData()
            }else if (self.mode == 1) {
                if (log != nil) && (log![0] == self.faculty![indexPath.row].id) {
                    return
                }
                let toRemove = self.faculty![indexPath.row]
                self.context.delete(toRemove)
                do {
                    try self.context.save()
                } catch {}
                self.fetchData()
            }else {
                let toRemove = self.tickets![indexPath.row]
                self.context.delete(toRemove)
                do {
                    try self.context.save()
                } catch {}
                self.fetchData()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - Actions
    
    /**
     Listens for when the selection has changed modes to update the list
     */
    @IBAction func changeListType(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex
        fetchData()
    }
}
