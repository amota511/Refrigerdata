//
//  TablesControllerViewController.swift
//  Refrigerdata
//
//  Created by amota511 on 8/16/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import Firebase
import SWRevealViewController


class FrigesController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var dbRef:FIRDatabaseReference!
    var usersFrigesNames: [String]!
    var usersFriges: [Frige]!
    var FrigesCollectionView: UICollectionView!
    var ListCollectionView: UICollectionView!
    
    let FrigesLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Friges"
        lb.textAlignment = .Center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.whiteColor()
        lb.font = lb.font.fontWithSize(23)
        return lb
    }()
    
    let Listslabel: UILabel = {
        let lb = UILabel()
        lb.text = "Lists"
        lb.textAlignment = .Center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.whiteColor()
        lb.font = lb.font.fontWithSize(23)
        return lb
    }()

    
    lazy var addFrigeButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        button.setTitle("+", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(26)
        button.addTarget(self, action: #selector(handleAddTable), forControlEvents: .TouchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var addListButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        button.setTitle("+", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(26)
        button.addTarget(self, action: #selector(handleAddList), forControlEvents: .TouchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    @IBOutlet var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("Friges")
        //sendFirstFrige()
        ObserveUserFrige()
        //startObservingDB()
        view.backgroundColor = UIColor(r: 100, g: 200, b: 100)
        
        let FrigeLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        FrigeLayout.sectionInset = UIEdgeInsets(top: -55, left: 10, bottom: 10, right: 10)
        FrigeLayout.itemSize = CGSize(width: view.frame.width * (1/3), height: view.frame.height * (1/3) * (3/4))
        FrigeLayout.scrollDirection = .Horizontal
        
        FrigesCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/7), width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: FrigeLayout)
        FrigesCollectionView.dataSource = self
        FrigesCollectionView.delegate = self
        FrigesCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "FrigeCell")
        FrigesCollectionView.scrollEnabled = true
        FrigesCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        FrigesCollectionView.showsHorizontalScrollIndicator = false
        FrigesCollectionView.restorationIdentifier = "Friges"
        
        //FrigesCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        //FrigesCollectionView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50)
        //FrigesCollectionView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 1/3)
        //FrigesCollectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor)
        
        //FrigesCollectionView.collectionViewLayout = FrigeLayout
        
        self.view.addSubview(FrigesCollectionView)
        
        FrigesCollectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1)

        self.view.addSubview(FrigesLabel)
        FrigesLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        FrigesLabel.bottomAnchor.constraintEqualToAnchor(FrigesCollectionView.topAnchor, constant: -5).active = true
        FrigesLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        FrigesLabel.heightAnchor.constraintEqualToAnchor(FrigesCollectionView.heightAnchor, multiplier: 1/6).active = true
        
        self.view.addSubview(addFrigeButton)
        addFrigeButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        addFrigeButton.topAnchor.constraintEqualToAnchor(FrigesCollectionView.bottomAnchor, constant: -8).active = true
        addFrigeButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 15/16).active = true
        addFrigeButton.heightAnchor.constraintEqualToAnchor(FrigesCollectionView.heightAnchor, multiplier: 1/6).active = true
        
        
        
        let ListLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        ListLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        ListLayout.itemSize = CGSize(width: view.frame.width * (1/3), height: view.frame.height * (1/3) * (3/4))
        ListLayout.scrollDirection = .Horizontal
 
        ListCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/3.5) + FrigesCollectionView.frame.height * 1.00, width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: ListLayout)
        ListCollectionView.dataSource = self
        ListCollectionView.delegate = self
        ListCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        ListCollectionView.scrollEnabled = true
        ListCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        ListCollectionView.showsHorizontalScrollIndicator = false
        ListCollectionView.restorationIdentifier = "Lists"
        self.view.addSubview(ListCollectionView)
        
        
        self.view.addSubview(Listslabel)
        Listslabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        Listslabel.bottomAnchor.constraintEqualToAnchor(ListCollectionView.topAnchor, constant: -5).active = true
        Listslabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        Listslabel.heightAnchor.constraintEqualToAnchor(ListCollectionView.heightAnchor, multiplier: 1/6).active = true
        
        self.view.addSubview(addListButton)
        addListButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        addListButton.topAnchor.constraintEqualToAnchor(ListCollectionView.bottomAnchor, constant: -8).active = true
        addListButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 15/16).active = true
        addListButton.heightAnchor.constraintEqualToAnchor(ListCollectionView.heightAnchor, multiplier: 1/6).active = true
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func sendFirstFrige(){
        FIRDatabase.database().reference().child("Friges").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let frige = Frige(name:"First", members: ["me": "myself", "and" : "I"], lists:["POINT": "ER", "TO" : "IT"])
            FIRDatabase.database().reference().child("Friges").childByAutoId().setValue(frige.toAnyObject())
        })

        
        
        
    }
    
    func ObserveUserFrige(){
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("friges").observeSingleEventOfType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newFrigeNames = [String]()
            
            //print(snapshot.value!)
            for frigeName in snapshot.value as! NSDictionary{
                //print(frigeName.key,frigeName.value)
                
                newFrigeNames.append(frigeName.value as! String)
            }
            self.usersFrigesNames = newFrigeNames
            /*
            if self.tableView.indexPathForSelectedRow != nil {
                self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
                self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
            }
             */
            self.FrigesCollectionView.reloadData()
            
            
            //self.ListCollectionView.reloadData()
        }) { (error:NSError) in
            print(error.description)
        }
        startObservingDB()
    }
    
    func startObservingDB(){
        FIRDatabase.database().reference().child("Friges").observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newfriges = [Frige]()
            for frige in self.usersFrigesNames{
                
                let frigeObject = Frige(snapshot:snapshot.childSnapshotForPath(frige))
                newfriges.append(frigeObject)
            }
            self.usersFriges = newfriges
            /*
             if self.tableView.indexPathForSelectedRow != nil {
             self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
             self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
             }
             */
            print(self.usersFriges)
            self.FrigesCollectionView.reloadData()
            //self.ListCollectionView.reloadData()
        }) { (error:NSError) in
            print(error.description)
        }
        
    }
    
    func handleAddList()  {
        
    }
    
    func handleAddTable(){
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "Friges"{
            return 9
        }else{
            return 9
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier == "Friges"{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FrigeCell", forIndexPath: indexPath)
        
            
            cell.backgroundColor = UIColor.whiteColor()
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.heightAnchor.constraintEqualToAnchor(collectionView.heightAnchor, multiplier: 3/4)
            cell.widthAnchor.constraintEqualToAnchor(collectionView.widthAnchor, multiplier: 1/3)
            
            let ListsImage = UIImageView()
            ListsImage.contentMode = .ScaleAspectFill
            ListsImage.translatesAutoresizingMaskIntoConstraints = false
            ListsImage.image = UIImage(named: "")
            
            cell.addSubview(ListsImage)
            
            ListsImage.centerXAnchor.constraintEqualToAnchor(cell.centerXAnchor).active = true
            ListsImage.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
            ListsImage.widthAnchor.constraintEqualToAnchor(cell.widthAnchor).active = true
            ListsImage.heightAnchor.constraintEqualToAnchor(cell.heightAnchor).active = true
            
        
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.whiteColor()
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.heightAnchor.constraintEqualToAnchor(collectionView.heightAnchor, multiplier: 3/4)
            cell.widthAnchor.constraintEqualToAnchor(collectionView.widthAnchor, multiplier: 1/3)
            
            return cell
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}