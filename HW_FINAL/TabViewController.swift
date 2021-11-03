//
//  TabViewController.swift
//  HW_FINAL
//
//  Created by Dylan Downard on 6/23/21.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = LoginNavController()
        let icon1 = UITabBarItem(title: "Login", image: UIImage(named: "person.fill"), selectedImage: UIImage(named: "person.fill"))
        
        item1.tabBarItem = icon1
        let controllers = [item1]
        self.viewControllers = controllers
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
            case "Login":
                print("hello")
                break
            default:
                break
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            print("Should select viewController: \(viewController.title ?? "") ?")
            return true;
        }

}
