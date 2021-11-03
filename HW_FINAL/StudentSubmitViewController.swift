//
//  StudentSubmitViewController.swift
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
/// View Controller that handles the Student's ability to sumbit tickets to faculty. The student is able to pick any faculty from a dropdown, and submit a ticket to any faculty that does not currently have a ticket with the student inside of them (thus, 1 ticket from a student per faculty.)
class StudentSubmitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //context for queries
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //collection of faculty able to be listed
    var faculty:[Faculty]?
    
    //information of user to be stored for convenience
    var id:String?
    var name:String?
    
    // MARK: - UIElements
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var facultyField: UITextField!
    
    // MARK: - Main Functions
    /**
     Every time this view loads, check if it should be allowed to be viewed. If it can, check if we are viewing the correct view. If so, fetch faculty and put in the collection. Set up the faculty input field.
     */
    override func viewDidAppear(_ animated: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        
        if log![2] == "faculty" {
            let vc = storyboard?.instantiateViewController(identifier: "ticketViewID") as! TicketViewController
            navigationController?.setViewControllers([vc], animated: true)
            return
        }
        
        do {
            self.faculty = try context.fetch(Faculty.fetchRequest())
        } catch {}
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        self.facultyField.inputView = picker
    }
    
    // MARK: - Helper Functions
    /**
     Function to get amount of rows in the picker, accounts for 1 empty to start
     
     - Returns: Amount of rows in the picker.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "" : self.faculty?[row-1].name
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     Function to get the amount of components in the picker, which is defaulty 1.
     - Returns: Amount of components in picker
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Function to get the count of elements in each component, which is the amount of faculty plus 1.
     - Returns: Amount of faculty in faculty array, plus 1 accounting for empty row.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (faculty!.count + 1)
    }
    
    /**
     Function sets the text of the textfield when a faculty is selected from the picker.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            return
        }
        self.facultyField.text = self.faculty?[row-1].name
        self.facultyField.endEditing(true)
    }
    
    /**
     Function that hides the text displayed after making an appointment
     */
    @objc func dismissApt() {
        self.errorLabel.textColor = UIColor.clear
        self.errorLabel.text = "You already have an appointment with them!"
    }
    
    // MARK: - Actions
    
    /**
     Action for button that allows user to attempt to add an appointment with the listed faculty.
     */
    @IBAction func makeAppointmentPressed(_ sender: UIButton) {
        var selectedFaculty:Faculty?
        
        for fac in faculty! {
            if fac.name == facultyField.text {
                selectedFaculty = fac
            }
        }
        
        if selectedFaculty == nil {
            return
        }
        do {
            //if you already have a reservation with this person, say no
            let request = Reservation.fetchRequest() as NSFetchRequest<Reservation>
            let pred = NSPredicate(format: "student_id = %@ AND faculty_id = %@", id!, selectedFaculty!.id!)
            request.predicate = pred
            let result = try context.fetch(request)
            
            if result.isEmpty == false {
                self.errorLabel.textColor = UIColor.red
                return
            }
            
            let reserve = Reservation(context: self.context)
            reserve.date_created = Date.init()
            reserve.faculty_id = selectedFaculty!.id
            reserve.faculty_name = selectedFaculty!.name
            reserve.student_id = id
            reserve.student_name = name
            reserve.status = "created"
            try self.context.save()
            self.facultyField.text = ""
            self.errorLabel.textColor = UIColor.clear
            self.errorLabel.text = "Appointment made with \(selectedFaculty!.name!)!"
            self.errorLabel.textColor = UIColor.green
            //3 seconds after creating the appointment, the label confirming it will disappear
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissApt), userInfo: nil, repeats: false)
            return
        } catch {
            
        }
    }
    

}
