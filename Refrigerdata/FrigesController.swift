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
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.white
        lb.font = lb.font.withSize(23)
        return lb
    }()
    
    let Listslabel: UILabel = {
        let lb = UILabel()
        lb.text = "Lists"
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.white
        lb.font = lb.font.withSize(23)
        return lb
    }()

    
    lazy var addFrigeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.addTarget(self, action: #selector(handleAddTable), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var addListButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        button.setTitle("+", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.addTarget(self, action: #selector(handleAddList), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var FrigesSuperView: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        FrigeLayout.scrollDirection = .horizontal
        
        //self.view.addSubview(FrigesSuperView)
        
        
        FrigesCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/5.5), width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: FrigeLayout)
        FrigesCollectionView.dataSource = self
        FrigesCollectionView.delegate = self
        FrigesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FrigeCell")
        FrigesCollectionView.isScrollEnabled = true
        FrigesCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        FrigesCollectionView.showsHorizontalScrollIndicator = false
        FrigesCollectionView.restorationIdentifier = "Friges"
        
        self.view.addSubview(FrigesCollectionView)
        /*
        FrigesSuperView.leftAnchor.constraint(equalTo:view.leftAnchor)
        FrigesSuperView.topAnchor.constraint(equalTo:view.topAnchor, constant: 50)
        FrigesSuperView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 1/3)
        FrigesSuperView.widthAnchor.constraint(equalTo:view.widthAnchor)
        */
        //FrigesCollectionView.collectionViewLayout = FrigeLayout
        
        
        //self.view.addSubview(FrigesCollectionView)
        
        FrigesCollectionView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 1)

        self.view.addSubview(FrigesLabel)
        FrigesLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        FrigesLabel.bottomAnchor.constraint(equalTo:FrigesCollectionView.topAnchor, constant: -5).isActive = true
        FrigesLabel.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        FrigesLabel.heightAnchor.constraint(equalTo:FrigesCollectionView.heightAnchor, multiplier: 1/6).isActive = true
        
        self.view.addSubview(addFrigeButton)
        addFrigeButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        addFrigeButton.topAnchor.constraint(equalTo:FrigesCollectionView.bottomAnchor, constant: -8).isActive = true
        addFrigeButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 15/16).isActive = true
        addFrigeButton.heightAnchor.constraint(equalTo:FrigesCollectionView.heightAnchor, multiplier: 1/6).isActive = true
        
        
        
        let ListLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        ListLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        ListLayout.itemSize = CGSize(width: view.frame.width * (1/3), height: view.frame.height * (1/3) * (3/4))
        ListLayout.scrollDirection = .horizontal
 
        ListCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/3.5) + FrigesCollectionView.frame.height * 1.00, width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: ListLayout)
        ListCollectionView.dataSource = self
        ListCollectionView.delegate = self
        ListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        ListCollectionView.isScrollEnabled = true
        ListCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        ListCollectionView.showsHorizontalScrollIndicator = false
        ListCollectionView.restorationIdentifier = "Lists"
        self.view.addSubview(ListCollectionView)
        
        
        self.view.addSubview(Listslabel)
        Listslabel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        Listslabel.bottomAnchor.constraint(equalTo:ListCollectionView.topAnchor, constant: -5).isActive = true
        Listslabel.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        Listslabel.heightAnchor.constraint(equalTo:ListCollectionView.heightAnchor, multiplier: 1/6).isActive = true
        
        self.view.addSubview(addListButton)
        addListButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        addListButton.topAnchor.constraint(equalTo:ListCollectionView.bottomAnchor, constant: -8).isActive = true
        addListButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 15/16).isActive = true
        addListButton.heightAnchor.constraint(equalTo:ListCollectionView.heightAnchor, multiplier: 1/6).isActive = true
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func sendFirstFrige(){
        FIRDatabase.database().reference().child("Friges").observeSingleEvent(of: .value, with: { (snapshot) in
            //let frige = Frige(name:"First", members: [(FIRAuth.auth()?.currentUser?.uid)! : true, "j0o9DGEnELOQCtfrfQ1fh8FeJCj1" : true], lists:["POINT": "ER", "TO" : "IT"])
            //FIRDatabase.database().reference().child("Friges").childByAutoId().setValue(frige.toAnyObject())
        })

    }
    
    func ObserveUserFrige(){
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("friges").observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
            var newFrigeNames = [String]()
            
            //print(snapshot.value!)
            if let value = snapshot.value as? NSDictionary{
                for frige in value {
                    print(frige.key,frige.value)
                    newFrigeNames.append(frige.value as! String)
                }

            }
            self.usersFrigesNames = newFrigeNames
            self.startObservingDB()
            /*
            if self.tableView.indexPathForSelectedRow != nil {
                self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
                self.tableView.deselectRow(at:self.tableView.indexPathForSelectedRow!, animated: true)
            }
             */
            self.FrigesCollectionView.reloadData()
            
            
            //self.ListCollectionView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        //startObservingDB()
    }
    
    func startObservingDB(){
        print(self.usersFrigesNames)
        for frige in self.usersFrigesNames{
        FIRDatabase.database().reference().child("Friges").child(frige).observe(.value, with: { (snapshot:FIRDataSnapshot) in
            
            var newfriges = [Frige]()
            let frigeObject = Frige(snapshot: snapshot)
            newfriges.append(frigeObject)
            self.usersFriges = newfriges
            /*
             if self.tableView.indexPathForSelectedRow != nil {
             self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
             self.tableView.deselectRow(at:self.tableView.indexPathForSelectedRow!, animated: true)
             }
             */
            print(self.usersFriges)
            self.FrigesCollectionView.reloadData()
            //self.ListCollectionView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
        }
    }
    
    func handleAddList()  {
        
    }
    
    func handleAddTable(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "Friges"{
            return 9
        }else{
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier == "Friges"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrigeCell", for: indexPath as IndexPath)
            
            cell.backgroundColor = UIColor.blue
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.heightAnchor.constraint(equalTo:collectionView.heightAnchor, multiplier: 3/4)
            cell.widthAnchor.constraint(equalTo:collectionView.widthAnchor, multiplier: 1/3)
            
            let ListsImage = UIImageView()
            ListsImage.contentMode = .scaleAspectFill
            ListsImage.translatesAutoresizingMaskIntoConstraints = false
            ListsImage.image = UIImage(named: "")
            
            cell.addSubview(ListsImage)
            
            ListsImage.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
            ListsImage.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
            ListsImage.widthAnchor.constraint(equalTo:cell.widthAnchor).isActive = true
            ListsImage.heightAnchor.constraint(equalTo:cell.heightAnchor).isActive = true
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.white
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.heightAnchor.constraint(equalTo:collectionView.heightAnchor, multiplier: 3/4)
            cell.widthAnchor.constraint(equalTo:collectionView.widthAnchor, multiplier: 1/3)
            
            return cell
        }
    }
}
