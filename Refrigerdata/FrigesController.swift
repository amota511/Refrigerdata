//
//  TablesControllerViewController.swift
//  Refrigerdata
//
//  Created by amota511 on 8/16/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import Firebase


extension FrigesController: UICollectionViewDataSource {
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView.restorationIdentifier == "Friges"{

            self.usersListsNames = self.usersFriges[indexPath.row].lists
            var newlistArray = [List]()
            for listName in self.usersListsNames {
                FIRDatabase.database().reference().child("Lists").child(listName).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    newlistArray.append( List(snapshot: snapshot) )
                    self.usersLists = newlistArray
                    self.ListCollectionView.reloadData()
                })
 
            }
        }else{
            let path = self.usersListsNames[indexPath.row]
            
            let lvc = Sweets(Path: path)
            self.navigationController?.pushViewController(lvc, animated: true)
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Lobster-Regular", size: 22)!]
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "Friges"{
            
            if let num = self.usersFriges {
                return num.count
            }
            return 0
        }else{
            
            let num = self.usersLists
            return num.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier == "Friges"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrigeCell", for: indexPath)
            
            cell.backgroundColor = UIColor.white
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            
            let frigeTitle = UILabel()

            if let title = self.usersFriges?[indexPath.row] {
                
                frigeTitle.text = title.name
                frigeTitle.textAlignment = .center
                frigeTitle.textRect(forBounds: cell.frame, limitedToNumberOfLines: 10)
                
                frigeTitle.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(frigeTitle)
                
                frigeTitle.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
                frigeTitle.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
                frigeTitle.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1/5).isActive = true
                frigeTitle.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            }
            
            let FrigeImage = UIImageView()
            FrigeImage.contentMode = .scaleAspectFit
            FrigeImage.translatesAutoresizingMaskIntoConstraints = false
            //FrigeImage.image = #imageLiteral(resourceName: "silver_frige1")
            
            cell.addSubview(FrigeImage)
            
            FrigeImage.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
            FrigeImage.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
            FrigeImage.widthAnchor.constraint(equalTo:cell.widthAnchor).isActive = true
            FrigeImage.heightAnchor.constraint(equalTo:cell.heightAnchor).isActive = true
            
            
            cell.bringSubview(toFront: frigeTitle)

            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            
            
            let listTitle = UILabel()
            
            let title = self.usersLists[indexPath.row]
                
                
                
                listTitle.textAlignment = .center
                listTitle.lineBreakMode = .byWordWrapping
                listTitle.numberOfLines = 0
                listTitle.text = title.name
                
                listTitle.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(listTitle)
                
                listTitle.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
                listTitle.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
                listTitle.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
                listTitle.widthAnchor.constraint(equalTo:cell.widthAnchor).isActive = true
            
            
            let listImage = UIImageView()
            listImage.contentMode = .scaleAspectFill
            listImage.translatesAutoresizingMaskIntoConstraints = false
            listImage.image = #imageLiteral(resourceName: "notebook_paper")
            
            cell.addSubview(listImage)
            
            listImage.centerXAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
            listImage.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
            listImage.widthAnchor.constraint(equalTo:cell.widthAnchor).isActive = true
            listImage.heightAnchor.constraint(equalTo:cell.heightAnchor).isActive = true
            
            cell.bringSubview(toFront: listTitle)
            return cell
        }
    }
}

class FrigesController: UIViewController,  UICollectionViewDelegateFlowLayout {
    
    
    var dbRef:FIRDatabaseReference!
    var usersFrigesNames: [String]!
    var usersFriges: [Frige]!
    var usersListsNames = [String]()
    var usersLists = [List]()
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
        button.addTarget(self, action: #selector(handleAddFrige), for: .touchUpInside)
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
    
    var frigeListView: UIView?
    
    
    @IBAction func LogoutButton(_ sender: UIBarButtonItem) {
        do{
            try FIRAuth.auth()?.signOut()
            self.dismiss(animated: true, completion: nil)
            
        }catch let logoutError {
            print(logoutError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("Friges")
        ObserveUserFrige()
        view.backgroundColor = UIColor(r: 100, g: 200, b: 100)
        
        let FrigeLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        FrigeLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        FrigeLayout.itemSize = CGSize(width: view.frame.width * (1/3), height: view.frame.height * (1/3) * (3/4))
        FrigeLayout.scrollDirection = .horizontal
        
        
        
        FrigesCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/13.5), width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: FrigeLayout)
        FrigesCollectionView.dataSource = self
        FrigesCollectionView.delegate = self
        FrigesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FrigeCell")
        FrigesCollectionView.isScrollEnabled = true
        FrigesCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        FrigesCollectionView.showsHorizontalScrollIndicator = false
        FrigesCollectionView.allowsSelection = true
        FrigesCollectionView.restorationIdentifier = "Friges"
        FrigesCollectionView.alwaysBounceHorizontal = true
        FrigesCollectionView.bounces = true
        
        self.view.addSubview(FrigesCollectionView)
        
        //FrigesCollectionView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 1)

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
 
        ListCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * (1/4.5) + FrigesCollectionView.frame.height * 1.00, width: view.frame.width, height: view.frame.height * (1/3.5)), collectionViewLayout: ListLayout)
        ListCollectionView.dataSource = self
        ListCollectionView.delegate = self
        ListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        ListCollectionView.isScrollEnabled = true
        ListCollectionView.backgroundColor = UIColor(r: 85, g: 185, b: 85)
        ListCollectionView.showsHorizontalScrollIndicator = false
        ListCollectionView.restorationIdentifier = "Lists"
        ListCollectionView.alwaysBounceHorizontal = true
        ListCollectionView.bounces = true
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
        
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        
        
        
    }
    

    func sendFirstFrige(){
        
        let frige = Frige(name:"Home", members: [(FIRAuth.auth()?.currentUser?.uid)!, "j0o9DGEnELOQCtfrfQ1fh8FeJCj1"], lists: ["-KWF_86Uxk-0kbQzy7G9","-KWLgC2-1fir3LeGHTzZ"])
        FIRDatabase.database().reference().child("Friges").childByAutoId().setValue(frige.toAnyObject())
        
    }
    
    func ObserveUserFrige(){
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("friges").observe(.value, with: { (snapshot:FIRDataSnapshot) in
            var newFrigeNames = [String]()

            if let value = snapshot.value as? [String]{
                
                for frige in value {
                    newFrigeNames.append(frige)
                }
            }

            self.usersFrigesNames = newFrigeNames
            self.startObservingDB()

        }) { (error: Error) in
            print(error.localizedDescription)
        }

    }
    
    func startObservingDB(){
        
        var newfriges = [Frige]()
        
        for frige in self.usersFrigesNames {
            
            FIRDatabase.database().reference().child("Friges").child(frige).observe(.value, with: { (snapshot:FIRDataSnapshot) in
                
                let frigeObject = Frige(snapshot: snapshot)
                newfriges.append(frigeObject)
                
                
                
                self.usersListsNames.append(frigeObject.name)
                self.usersFriges = newfriges
                
                self.FrigesCollectionView.reloadData()
                self.ListCollectionView.reloadData()
                
                print(self.usersFrigesNames)
                
            }) { (error: Error) in
                print(error.localizedDescription)
            }
            
        }
        
    }
    func handleAddFrige(){
        
        let fridgeAlert = UIAlertController(title: "New Fridge", message: "Enter Your Fridge Name", preferredStyle: .alert)
       
        fridgeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your New Fridge"
            textField.autocapitalizationType = .words
        }
        fridgeAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: {(UIAlertAction) in
            if let fridgeName = fridgeAlert.textFields?.first?.text{
                
                let userID = (FIRAuth.auth()?.currentUser?.uid)!
                
                let fridge = Frige(name: fridgeName, members: [userID], lists: ["-KWLgC2-1fir3LeGHTzZ"])
                
                let fridgeRef = FIRDatabase.database().reference().child("Friges").childByAutoId()
                
                fridgeRef.setValue(fridge.toAnyObject())
                
                self.usersFrigesNames.append(fridgeRef.key)
                
                FIRDatabase.database().reference().child("Users").child(userID).child("friges").setValue([self.usersFrigesNames.description])
                self.FrigesCollectionView.reloadData()
            }
            
        }))
        
        fridgeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            fridgeAlert.dismiss(animated:false, completion: nil)
        }))
        
        self.present(fridgeAlert, animated: true, completion: nil)

        
        /*
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(r: 75, g: 75, b: 75)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.frame = self.view.bounds

        //self.view.addSubview(backgroundView)
       
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        
        let cancelButton = createCancelButton()
        blurView.contentView.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 24).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -24).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 1/9).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 1/15).isActive = true
        
        
        let frigeListSwitch = createFrigeLstSegmentedControl(cancelButton: cancelButton)
        blurView.contentView.addSubview(frigeListSwitch)
        setFrigeListSegmentedControl(switchControl: frigeListSwitch, cancelButton: cancelButton)
        
        let containerView = createFrigeListContainer(frigeListSwitch: frigeListSwitch)
        frigeListView = containerView
        blurView.contentView.addSubview(containerView)
        setFrigeListContainer(view: containerView, segmentedSwitch: frigeListSwitch)
        
        let addFrigeListButton = createAddFrigeListButton()
        blurView.contentView.addSubview(addFrigeListButton)
        setAddFrigeButton(button: addFrigeListButton, superview: containerView)
        
        let nameLabel = createNewNameLabel()
        containerView.addSubview(nameLabel)
        setNewNameLabel(label: nameLabel, superview: containerView)
        */
    }
    
    func createNewNameLabel() -> UILabel {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.text = "Name"
        lb.font = UIFont.systemFont(ofSize: 16, weight: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }
    
    func setNewNameLabel(label: UILabel, superview: UIView){
        label.topAnchor.constraint(equalTo: superview.topAnchor, constant: 6).isActive = true
        label.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1/2).isActive = true
        label.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1/8).isActive = true
        
    }
    
    
    func createCancelButton() -> UIButton {
        let cancel = UIButton(type: .system)
        cancel.setTitle("X", for: .normal)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitleColor(UIColor.white, for: .normal)
        cancel.addTarget(self, action: #selector(removeBlur(sender:)), for: .touchUpInside)
        return cancel
    }
    
    func removeBlur(sender: UIButton) {
        let blurView = sender.superview?.superview
        blurView?.removeFromSuperview()
        print("The blur view should be removed")
        
    }
    
    func createFrigeLstSegmentedControl(cancelButton: UIButton) -> UISegmentedControl {
        let switchControl = UISegmentedControl(items: ["Frige", "List"])
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.tintColor = .white
        switchControl.setTitleTextAttributes(["Color": "White"], for: .normal)
        switchControl.selectedSegmentIndex = 0
        switchControl.addTarget(self, action: #selector(frigeListSegmentedControlSwitch(sender:)), for: .valueChanged)
        return switchControl
    }
    
    func setFrigeListSegmentedControl(switchControl: UISegmentedControl, cancelButton: UIButton) {
        switchControl.topAnchor.constraint(equalTo: cancelButton.bottomAnchor).isActive = true
        switchControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        switchControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true
        switchControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/16).isActive = true
    }
    
    func frigeListSegmentedControlSwitch(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if let frigeView = frigeListView {
                print(0)
            }
        }else if sender.selectedSegmentIndex == 1 {
            if let listView = frigeListView {
                print(1)
            }
        }
    }
    
    func createFrigeListContainer(frigeListSwitch: UISegmentedControl) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        return view
    }
    
    func setFrigeListContainer(view: UIView, segmentedSwitch: UISegmentedControl) {
        view.topAnchor.constraint(equalTo: segmentedSwitch.bottomAnchor, constant: 12).isActive = true
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 3/6).isActive = true
    }
    
    func createAddFrigeListButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Add Frige", for: .normal)
        button.setTitleColor(UIColor(r: 115, g: 215, b: 115), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.white
        return button
    }
    
    func setAddFrigeButton(button: UIButton, superview: UIView) {
        
        button.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: 12).isActive = true
        button.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1/6).isActive = true
        
    }
    
    func handleAddList()  {
        
        
    }
    
    
}
