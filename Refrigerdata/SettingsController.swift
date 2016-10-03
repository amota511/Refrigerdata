//
//  SettingsController.swift
//  Refrigerdata
//
//  Created by amota511 on 8/16/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsController: UIViewController {
    
    let nameViewBubble: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let nameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 120, g: 220, b: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let SettingsLabel:UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    @IBOutlet var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        
        
        
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            setupView()
            
        }
        
    }
    
    func setupView(){
        
        self.view.addSubview(nameView)
        self.view.addSubview(nameView)
        self.view.addSubview(nameView)
        nameView.addSubview(nameViewBubble)
        nameView.addSubview(nameViewBubble)
        nameView.addSubview(nameViewBubble)
        
        
        nameView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo:view.topAnchor, constant: view.frame.height * 1/5).isActive = true
        nameView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 1/1.25).isActive = true
        nameView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 1/16).isActive = true
        nameViewBubble.leftAnchor.constraint(equalTo:nameView.leftAnchor).isActive = true
        nameViewBubble.centerYAnchor.constraint(equalTo:nameView.centerYAnchor).isActive = true
        nameViewBubble.widthAnchor.constraint(equalTo:nameView.widthAnchor, multiplier: 1/6).isActive = true
        nameViewBubble.heightAnchor.constraint(equalTo:nameView.heightAnchor).isActive = true
        
        
        
        
        nameView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo:view.topAnchor, constant: view.frame.height * 1/5).isActive = true
        nameView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 1/1.25).isActive = true
        nameView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 1/16).isActive = true
        nameViewBubble.leftAnchor.constraint(equalTo:nameView.leftAnchor).isActive = true
        nameViewBubble.centerYAnchor.constraint(equalTo:nameView.centerYAnchor).isActive = true
        nameViewBubble.widthAnchor.constraint(equalTo:nameView.widthAnchor, multiplier: 1/6).isActive = true
        nameViewBubble.heightAnchor.constraint(equalTo:nameView.heightAnchor).isActive = true
        
        
        
        
        nameView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo:view.topAnchor, constant: view.frame.height * 1/5).isActive = true
        nameView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 1/1.25).isActive = true
        nameView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 1/16).isActive = true
        nameViewBubble.leftAnchor.constraint(equalTo:nameView.leftAnchor).isActive = true
        nameViewBubble.centerYAnchor.constraint(equalTo:nameView.centerYAnchor).isActive = true
        nameViewBubble.widthAnchor.constraint(equalTo:nameView.widthAnchor, multiplier: 1/6).isActive = true
        nameViewBubble.heightAnchor.constraint(equalTo:nameView.heightAnchor).isActive = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
