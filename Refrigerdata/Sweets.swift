//
//  Sweets.swift
//  Refrigerdata
//
//  Created by amota511 on 8/13/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SWRevealViewController

class Sweets: UITableViewController {

    
    var dbRef:FIRDatabaseReference!
    var sweets = [Sweet]()
    var rowIsSelected = false
    var AnyRowIsSelected = false
    var usersName:String!
    
    lazy var ownItButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mine!", forState: .Normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleOwnIt), forControlEvents: .TouchUpInside)
    return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        //let image = UIImage(named: "white_X")
        button.setTitle("X", forState: .Normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleDelete), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check", forState: .Normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCheck), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 120, g: 220, b: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    @IBOutlet var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = FIRDatabase.database().reference().child("sweet-items")
        startObservingDB()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("Users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.usersName = snapshot.value?.objectForKey("name") as! String
        })
       
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
       

    }

    func startObservingDB(){
        dbRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newSweets = [Sweet]()
            for sweet in snapshot.children{
                let sweetObject = Sweet(snapshot:sweet as! FIRDataSnapshot)
                newSweets.append(sweetObject)
            }
            self.sweets = newSweets
            if self.tableView.indexPathForSelectedRow != nil {
                self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
                self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
            }
                self.tableView.reloadData()
        }) { (error:NSError) in
                print(error.description)
        }
        
    }
    
    
    
    @IBAction func addSweet(sender: AnyObject) {
        let sweetAlert = UIAlertController(title: "New Item", message: "Enter Your Item", preferredStyle: .Alert)
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView(self.tableView, didDeselectRowAtIndexPath: self.tableView.indexPathForSelectedRow!)
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        }
        sweetAlert.addTextFieldWithConfigurationHandler{
            (textField:UITextField) in
            textField.placeholder = "Your Item"
            textField.autocapitalizationType = .Words
        }
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: {(UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text{
                let userID = FIRAuth.auth()?.currentUser?.uid
                FIRDatabase.database().reference().child("Users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let sweet = Sweet(content: sweetContent, addedByUser: self.usersName)
                    let sweetRef = self.dbRef.child(sweetContent.lowercaseString)
                    sweetRef.setValue(sweet.toAnyObject())
                })
            }
        
        }))
        
        sweetAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
            sweetAlert.dismissViewControllerAnimated(false, completion: nil)
        }))
        
        self.presentViewController(sweetAlert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sweets.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            AnyRowIsSelected = true
            rowIsSelected = true
        }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RefrigerdataCell
        
        if rowIsSelected == false {
        cell.backgroundColor = UIColor(r: 120, g: 220, b: 120)
        cell.item.textColor = UIColor.whiteColor()
        cell.detail.textColor = UIColor.whiteColor()
        
        cell.addSubview(coverView)
        coverView.addSubview(ownItButton)
        coverView.addSubview(checkButton)
        coverView.addSubview(deleteButton)
            
        coverView.leftAnchor.constraintEqualToAnchor(cell.centerXAnchor, constant: -10).active = true
        coverView.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
        coverView.rightAnchor.constraintEqualToAnchor(cell.rightAnchor).active = true
        coverView.heightAnchor.constraintEqualToAnchor(cell.heightAnchor).active = true
        
        ownItButton.leftAnchor.constraintEqualToAnchor(cell.centerXAnchor).active = true
        ownItButton.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
        ownItButton.widthAnchor.constraintEqualToAnchor(cell.widthAnchor, multiplier: 1/7).active = true
        ownItButton.heightAnchor.constraintEqualToAnchor(cell.heightAnchor, multiplier: 3/4).active = true
        
        checkButton.leftAnchor.constraintEqualToAnchor(ownItButton.rightAnchor, constant: 2).active = true
        checkButton.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
        checkButton.rightAnchor.constraintEqualToAnchor(deleteButton.leftAnchor, constant: -2).active = true
        checkButton.heightAnchor.constraintEqualToAnchor(cell.heightAnchor, multiplier: 3/4).active = true
        
        deleteButton.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: -2).active = true
        deleteButton.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
        deleteButton.widthAnchor.constraintEqualToAnchor(cell.widthAnchor, multiplier: 1/7).active = true
        deleteButton.heightAnchor.constraintEqualToAnchor(cell.heightAnchor, multiplier: 3/4).active = true
        rowIsSelected = true
            
        }else{
            
            cell.backgroundColor = UIColor.whiteColor()
            cell.item.textColor = UIColor.blackColor()
            cell.detail.textColor = UIColor.blackColor()
            coverView.removeFromSuperview()
            ownItButton.removeFromSuperview()
            checkButton.removeFromSuperview()
            deleteButton.removeFromSuperview()
            
            /*
            cell.item.rightAnchor.constraintEqualToAnchor(cell.centerXAnchor, constant: -2).active = true
            cell.detail.rightAnchor.constraintEqualToAnchor(cell.centerXAnchor, constant: -2).active = true
            */
 
            rowIsSelected = false
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let sweet = sweets[indexPath.row]
            if sweet.owned == true{
                if sweet.ownedBy == self.usersName {
                    cell.item.textColor = UIColor(r: 218, g: 164, b: 32)
                    cell.detail.textColor = UIColor(r: 218, g: 164, b: 32)
                }else {
                    cell.item.textColor = UIColor(r: 100, g: 200, b: 100)
                    cell.detail.textColor = UIColor(r: 100, g: 200, b: 100)
                }
            }else{
                cell.item.textColor = UIColor.blackColor()
                cell.detail.textColor = UIColor.blackColor()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RefrigerdataCell
        
        
        coverView.removeFromSuperview()
        ownItButton.removeFromSuperview()
        checkButton.removeFromSuperview()
        deleteButton.removeFromSuperview()
        
        /*
        cell.item.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: -2).active = true
        cell.detail.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: -2).active = true
        */
        
 
        let sweet = sweets[indexPath.row]
        if sweet.owned == true{
            if sweet.ownedBy == self.usersName {
                cell.item.textColor = UIColor(r: 218, g: 164, b: 32)
                cell.detail.textColor = UIColor(r: 218, g: 164, b: 32)
            }else {
                cell.item.textColor = UIColor(r: 100, g: 200, b: 100)
                cell.detail.textColor = UIColor(r: 100, g: 200, b: 100)
            }
        }else{
            cell.item.textColor = UIColor.blackColor()
            cell.detail.textColor = UIColor.blackColor()
        }
        
        cell.backgroundColor = UIColor.whiteColor()
        rowIsSelected = false
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RefrigerdataCell
        let sweet = sweets[indexPath.row]
        
        
        cell.selectionStyle = .None
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        cell.item.translatesAutoresizingMaskIntoConstraints = false
        cell.item.text = sweet.content
        cell.addSubview(cell.item)
        cell.item.leftAnchor.constraintEqualToAnchor(cell.leftAnchor, constant: 24).active = true
        cell.item.bottomAnchor.constraintEqualToAnchor(cell.centerYAnchor, constant: 5).active = true
        cell.item.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: -2).active = true
        cell.item.topAnchor.constraintEqualToAnchor(cell.topAnchor).active = true
        
        
        cell.detail.translatesAutoresizingMaskIntoConstraints = false
        cell.detail.font = cell.detail.font.fontWithSize(10)
        
        
        let owned = sweet.owned
        let ownedBy = sweet.ownedBy

        if owned == true{
            if ownedBy == usersName {
                cell.detail.text = "Belongs to: Me"
                cell.item.textColor = UIColor(r: 218, g: 164, b: 32)
                cell.detail.textColor = UIColor(r: 218, g: 164, b: 32)
            }else{
                cell.detail.text = "Belongs to: \(ownedBy!)"
                cell.item.textColor = UIColor(r: 100, g: 200, b: 100)
                cell.detail.textColor = UIColor(r: 100, g: 200, b: 100)
            }
        }else{
            cell.detail.text = "Added by: \(sweet.addedByUser)"
            cell.item.textColor = UIColor.blackColor()
            cell.detail.textColor = UIColor.blackColor()
        }
        
        let checked = sweet.checked
        
        if checked! {
            let attributeItem: NSMutableAttributedString =  NSMutableAttributedString(string: cell.item.text!)
            attributeItem.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeItem.length))
            
            let attributeDetail: NSMutableAttributedString =  NSMutableAttributedString(string: cell.detail.text!)
            attributeDetail.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeDetail.length))
            
            cell.item.attributedText = attributeItem
            cell.detail.attributedText = attributeDetail
            
            cell.item.font = UIFont(name: "HelveticaNeue-LightItalic", size: 16)
            cell.detail.font = UIFont(name: "HelveticaNeue-Italic", size: 10)
        }else{
            cell.item.attributedText = NSMutableAttributedString(string: cell.item.text!)
            cell.detail.attributedText = NSMutableAttributedString(string: cell.detail.text!)
            cell.item.font = UIFont(name: "HelveticaNeue", size: 18)
            cell.detail.font = UIFont(name: "HelveticaNeue", size: 10)
        }
        
        
        cell.addSubview(cell.detail)
        cell.detail.leftAnchor.constraintEqualToAnchor(cell.leftAnchor, constant: 24).active = true
        cell.detail.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor).active = true
        cell.detail.rightAnchor.constraintEqualToAnchor(cell.rightAnchor, constant: -2).active = true
        cell.detail.topAnchor.constraintEqualToAnchor(cell.item.bottomAnchor).active = true
        
        return cell
    }
 
    func handleOwnIt(){
        let cell = self.tableView.cellForRowAtIndexPath((self.tableView.indexPathForSelectedRow)!) as! RefrigerdataCell
        var sweet = sweets[(self.tableView.indexPathForSelectedRow?.row)!]

        if sweet.owned == true {
            itemAlreadyOwned()
        }else{
            sweet.owned = true
            sweet.ownedBy = self.usersName
            
            dbRef.child(sweet.content.lowercaseString).updateChildValues(["owned":sweet.owned, "ownedBy": sweet.ownedBy!], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
            })
            cell.detail.text = "Belongs to: Me"
         }
    }
    
    func itemAlreadyOwned(){
        let sweet = sweets[(self.tableView.indexPathForSelectedRow?.row)!]
        let ownedBy = sweet.ownedBy
        if ownedBy == usersName {
            let ownedAlert = UIAlertController(title: "Already Yours 😁", message: nil, preferredStyle: .ActionSheet)
            ownedAlert.addAction(UIAlertAction(title: "Oh Yeah! 😅", style: .Cancel, handler: { (UIAlertAction) in
                ownedAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(ownedAlert, animated: true, completion: nil)
        }else{
            let ownedAlert = UIAlertController(title: "Item already owned 😅", message: nil, preferredStyle: .ActionSheet)
            ownedAlert.addAction(UIAlertAction(title: "Fine!", style: .Cancel, handler: { (UIAlertAction) in
                ownedAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(ownedAlert, animated: true, completion: nil)
        }
        
    }

    func handleDelete(){
        let cell = self.tableView.cellForRowAtIndexPath((self.tableView.indexPathForSelectedRow)!) as! RefrigerdataCell
        let item = cell.item.text!
        let sweetAlert = UIAlertController(title: "Are you sure you want to delete \(item) from this list?", message: nil, preferredStyle: .Alert)
        
        sweetAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {(UIAlertAction) in
            
            
                let sweet = self.sweets[(self.tableView.indexPathForSelectedRow?.row)!]
                let sweetRef = self.dbRef.child(sweet.content.lowercaseString)
                sweetRef.removeValueWithCompletionBlock({ (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                })
        }))
        
        sweetAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
            sweetAlert.dismissViewControllerAnimated(false, completion: nil)
        }))
        
        self.presentViewController(sweetAlert, animated: true, completion: nil)
        
    }
    
    func handleCheck(){
        var sweet = sweets[(self.tableView.indexPathForSelectedRow?.row)!]
        
      if sweet.checked != true {
        sweet.checked = true
        dbRef.child(sweet.content.lowercaseString).updateChildValues(["checked":sweet.checked], withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
        })
      }else{
        sweet.checked = false
        dbRef.child(sweet.content.lowercaseString).updateChildValues(["checked":sweet.checked], withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
        })
      }
}
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(.TraitBold, .TraitCondensed)
    }
    
}
