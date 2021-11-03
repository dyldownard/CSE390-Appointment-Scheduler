//
//  RegisterViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//  SBUID : 100150888

import UIKit
import CoreData
/**
  - Author:
 Dylan Downard
 */
/// ViewController that handles users registering, coming from LoginViewController. If the ID given already exists or any of the fields are blank, it will not create a user.
class RegisterViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //passes in the id and pass written in the fields from login
    var givenID:String?
    var givenPass:String?
    
    // MARK: - UIElements
    @IBOutlet weak var registerIDField: UITextField!
    @IBOutlet weak var registerPassField: UITextField!
    @IBOutlet weak var registerNameField: UITextField!
    @IBOutlet weak var registerSwitch: UISwitch!
    @IBOutlet weak var registerErrorLabel: UILabel!
    
    // MARK: - Main Functions
    /**
     After loading, add a tap action to dismiss the keyboard
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerIDField.text = givenID
        self.registerPassField.text = givenPass
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    /**
     When register is clicked, make sure the information given is eligible for registering. If it is, send back to login.
     */
    @IBAction func registerRegisterClicked(_ sender: UIButton) {
        let id = self.registerIDField.text
        let pass = self.registerPassField.text
        let name = self.registerNameField.text
        let mode = self.registerSwitch.isOn //true == faculty, false==student
        
        if id=="" || pass=="" || name=="" {
            self.registerErrorLabel.textColor = UIColor.red
            return
        }
        
        do {
            let srequest = Student.fetchRequest() as NSFetchRequest<Student>
            var pred = NSPredicate(format: "id CONTAINS %@", id!)
            srequest.predicate = pred
            let sresult = try context.fetch(srequest)
            
            if sresult.isEmpty == false {
                self.registerErrorLabel.textColor = UIColor.red
                return
            }
            
            let frequest = Faculty.fetchRequest() as NSFetchRequest<Faculty>
            pred = NSPredicate(format: "id CONTAINS %@", id!)
            frequest.predicate = pred
            let fresult = try context.fetch(frequest)
            
            if fresult.isEmpty == false {
                self.registerErrorLabel.textColor = UIColor.red
                return
            }
            
            if (mode == true) {
                let faculty = Faculty(context: self.context)
                faculty.id = id
                faculty.password = pass
                faculty.name = name
                try self.context.save()
                print("success!")
                _ = navigationController?.popViewController(animated: true)
            }else {
                let student = Student(context: self.context)
                student.id = id
                student.password = pass
                student.name = name
                try self.context.save()
                print("success!")
                _ = navigationController?.popViewController(animated: true)
            }
            
        } catch {}
    }
    
    // MARK: - Helper Functions
    /**
     Dismiss the keyboard
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
