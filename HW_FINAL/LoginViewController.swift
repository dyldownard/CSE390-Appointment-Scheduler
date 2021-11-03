//
//  LoginViewController.swift
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
/// View Controller that handles logging into a user's account.
class LoginViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - UIElements
    @IBOutlet weak var loginIDField: UITextField!
    @IBOutlet weak var loginPassField: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    // MARK: - Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Helper Functions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    /**
     Checks if a student exists with this ID and password, and then if a faculty exists. If one does exist, it logs the user in as that object, proceeding to the UserView scene.
     */
    @IBAction func loginPressed(_ sender: UIButton) {
        let id = self.loginIDField.text
        let pass = self.loginPassField.text
        
        if id=="" || pass=="" {
            self.loginErrorLabel.textColor = UIColor.red
            return
        }
        
        do {
            let srequest = Student.fetchRequest() as NSFetchRequest<Student>
            var pred = NSPredicate(format: "id = %@ AND password = %@", id!, pass!)
            srequest.predicate = pred
            let sresult = try context.fetch(srequest)
            
            if sresult.isEmpty == false {
               //student is logged in
                let defaults = UserDefaults.standard
                var ar:[String]
                ar = [sresult[0].id!, sresult[0].name!, "student"]
                defaults.set(ar, forKey: "userLog")
                let vc = storyboard?.instantiateViewController(identifier: "userViewID") as? UserViewController
                self.navigationController?.setViewControllers([vc!], animated: true)
                _ = navigationController?.popViewController(animated: true)
                return
            }
            
            let frequest = Faculty.fetchRequest() as NSFetchRequest<Faculty>
            pred = NSPredicate(format: "id = %@ AND password = %@", id!, pass!)
            frequest.predicate = pred
            let fresult = try context.fetch(frequest)
            
            if fresult.isEmpty == false {
                //faculty is logged in
                let defaults = UserDefaults.standard
                var ar:[String]
                ar = [fresult[0].id!, fresult[0].name!, "faculty"]
                defaults.set(ar, forKey: "userLog")
                let vc = storyboard?.instantiateViewController(identifier: "userViewID") as? UserViewController
                self.navigationController?.setViewControllers([vc!], animated: true)
                _ = navigationController?.popViewController(animated: true)
                return
            }
            
            self.loginErrorLabel.textColor = UIColor.red
            return
        } catch {}
    }
    
    /**
     When register button is pressed, swap over to the RegisterView
     */
    @IBAction func registerPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "registerScene") as? RegisterViewController
        vc?.givenID = loginIDField.text
        vc?.givenPass = loginPassField.text
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
