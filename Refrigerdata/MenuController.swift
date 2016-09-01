//
//  ViewController.swift
//  Refrigerdata
//
//  Created by amota511 on 8/15/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import Firebase


class MenuController: UITableViewController {

    @IBOutlet var tablesCell: UITableViewCell!
    @IBOutlet var settingsCell: UITableViewCell!
    @IBOutlet var logoutCell: UITableViewCell!
    @IBOutlet var titleCell: UITableViewCell!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(r: 100, g: 200, b: 100)
        titleCell.backgroundColor = UIColor.clearColor()
        
        tablesCell.selectionStyle = .None
        settingsCell.selectionStyle = .None
        logoutCell.selectionStyle = .None
        titleCell.selectionStyle = .None
        
        let Menu = UILabel()
        Menu.text = "MENU"
        Menu.textColor = UIColor.whiteColor()
        Menu.textAlignment = .Center
        Menu.translatesAutoresizingMaskIntoConstraints = false
        titleCell.addSubview(Menu)
        
        Menu.centerXAnchor.constraintEqualToAnchor(titleCell.centerXAnchor, constant: -26).active = true
        Menu.centerYAnchor.constraintEqualToAnchor(titleCell.centerYAnchor).active = true
        Menu.widthAnchor.constraintEqualToAnchor(titleCell.widthAnchor, multiplier: 1/5).active = true
        Menu.heightAnchor.constraintEqualToAnchor(titleCell.heightAnchor, multiplier: 3/4).active = true
        
        let Tables = UILabel()
        Tables.text = "Friges"
        Tables.textColor = UIColor(r: 85, g: 120, b: 85)
        Tables.textAlignment = .Center
        Tables.translatesAutoresizingMaskIntoConstraints = false
        tablesCell.addSubview(Tables)
        
        Tables.leftAnchor.constraintEqualToAnchor(tablesCell.leftAnchor, constant: -5).active = true
        Tables.centerYAnchor.constraintEqualToAnchor(tablesCell.centerYAnchor).active = true
        Tables.widthAnchor.constraintEqualToAnchor(tablesCell.widthAnchor, multiplier: 1/3).active = true
        Tables.heightAnchor.constraintEqualToAnchor(tablesCell.heightAnchor).active = true
        
        let Settings = UILabel()
        Settings.text = "Settings"
        Settings.textColor = UIColor(r: 85, g: 120, b: 85)
        Settings.textAlignment = .Center
        Settings.translatesAutoresizingMaskIntoConstraints = false
        settingsCell.addSubview(Settings)
        
        Settings.leftAnchor.constraintEqualToAnchor(settingsCell.leftAnchor).active = true
        Settings.centerYAnchor.constraintEqualToAnchor(settingsCell.centerYAnchor).active = true
        Settings.widthAnchor.constraintEqualToAnchor(settingsCell.widthAnchor, multiplier: 1/3).active = true
        Settings.heightAnchor.constraintEqualToAnchor(settingsCell.heightAnchor).active = true
        
        let logout = UIButton()
        logout.setTitle("Logout", forState: .Normal)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setTitleColor(UIColor(r: 85, g: 120, b: 85), forState: .Normal)
        logout.addTarget(self, action: #selector(handleLogout), forControlEvents: .TouchUpInside)
        logoutCell.addSubview(logout)
        
        logout.leftAnchor.constraintEqualToAnchor(logoutCell.leftAnchor).active = true
        logout.centerYAnchor.constraintEqualToAnchor(logoutCell.centerYAnchor).active = true
        logout.widthAnchor.constraintEqualToAnchor(logoutCell.widthAnchor, multiplier: 1/3).active = true
        logout.heightAnchor.constraintEqualToAnchor(logoutCell.heightAnchor).active = true
        
    }

    func handleLogout(){
        do{
        try FIRAuth.auth()?.signOut()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }catch let logoutError {
            print(logoutError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

