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
        titleCell.backgroundColor = UIColor.clear
        
        tablesCell.selectionStyle = .none
        settingsCell.selectionStyle = .none
        logoutCell.selectionStyle = .none
        titleCell.selectionStyle = .none
        
        let Menu = UILabel()
        Menu.text = "MENU"
        Menu.textColor = UIColor.white
        Menu.textAlignment = .center
        Menu.translatesAutoresizingMaskIntoConstraints = false
        titleCell.addSubview(Menu)
        
        Menu.centerXAnchor.constraint(equalTo:titleCell.centerXAnchor, constant: -26).isActive = true
        Menu.centerYAnchor.constraint(equalTo:titleCell.centerYAnchor).isActive = true
        Menu.widthAnchor.constraint(equalTo:titleCell.widthAnchor, multiplier: 1/5).isActive = true
        Menu.heightAnchor.constraint(equalTo:titleCell.heightAnchor, multiplier: 3/4).isActive = true
        
        let Tables = UILabel()
        Tables.text = "Friges"
        Tables.textColor = UIColor(r: 85, g: 120, b: 85)
        Tables.textAlignment = .center
        Tables.translatesAutoresizingMaskIntoConstraints = false
        tablesCell.addSubview(Tables)
        
        Tables.leftAnchor.constraint(equalTo:tablesCell.leftAnchor, constant: -5).isActive = true
        Tables.centerYAnchor.constraint(equalTo:tablesCell.centerYAnchor).isActive = true
        Tables.widthAnchor.constraint(equalTo:tablesCell.widthAnchor, multiplier: 1/3).isActive = true
        Tables.heightAnchor.constraint(equalTo:tablesCell.heightAnchor).isActive = true
        
        let Settings = UILabel()
        Settings.text = "Settings"
        Settings.textColor = UIColor(r: 85, g: 120, b: 85)
        Settings.textAlignment = .center
        Settings.translatesAutoresizingMaskIntoConstraints = false
        settingsCell.addSubview(Settings)
        
        Settings.leftAnchor.constraint(equalTo:settingsCell.leftAnchor).isActive = true
        Settings.centerYAnchor.constraint(equalTo:settingsCell.centerYAnchor).isActive = true
        Settings.widthAnchor.constraint(equalTo:settingsCell.widthAnchor, multiplier: 1/3).isActive = true
        Settings.heightAnchor.constraint(equalTo:settingsCell.heightAnchor).isActive = true
        
        let logout = UIButton()
        logout.setTitle("Logout", for: .normal)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setTitleColor(UIColor(r: 85, g: 120, b: 85), for: .normal)
        logout.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutCell.addSubview(logout)
        
        logout.leftAnchor.constraint(equalTo:logoutCell.leftAnchor).isActive = true
        logout.centerYAnchor.constraint(equalTo:logoutCell.centerYAnchor).isActive = true
        logout.widthAnchor.constraint(equalTo:logoutCell.widthAnchor, multiplier: 1/3).isActive = true
        logout.heightAnchor.constraint(equalTo:logoutCell.heightAnchor).isActive = true
        
    }
    
    func handleLogout(){
        do{
        try FIRAuth.auth()?.signOut()
            self.dismiss(animated: true, completion: nil)
            
        }catch let logoutError {
            print(logoutError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

