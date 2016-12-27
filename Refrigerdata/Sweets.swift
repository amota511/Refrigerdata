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
    var listName:String!
    
    lazy var ownItButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mine!", for: .normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleOwnIt), for: .touchUpInside)
    return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        //let image = UIImage(named: "white_X")
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check", for: .normal)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        return button
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 120, g: 220, b: 120)
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    @IBOutlet var menu: UIBarButtonItem!
    
    var path: String!
    
    init(Path: String) {
        super.init(style: .plain)
        
        path = Path
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startObservingDB()
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        print(userID)
        FIRDatabase.database().reference().child("Users").child(userID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            self.usersName = snapshot.value as! String
        })
       
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //self.navigationController?.navigationBar.barTintColor = UIColor(r: 100, g: 200, b: 100)
        /*
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
       */
        
        let plusSign = "+"
        
        let rightBarButton = UIBarButtonItem(title: "+",  style: .plain, target: self, action: #selector(addSweet(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func startObservingDB(){
        
        FIRDatabase.database().reference().child("Lists").child(path).child("name").observe(.value, with: { (snapshot:FIRDataSnapshot) in
            self.listName = snapshot.value as! String!
            self.tableView.reloadData()
            })
        
        FIRDatabase.database().reference().child("Lists").child(path).child("list").observe(.value, with: { (snapshot:FIRDataSnapshot) in
            
            var newSweets = [Sweet]()
            for sweet in snapshot.children{
                
                let sweetObject = Sweet(snapshot: sweet as! FIRDataSnapshot)
                newSweets.append(sweetObject)
                
            }
            self.sweets = newSweets
            if self.tableView.indexPathForSelectedRow != nil {
                
                self.tableView(self.tableView, didDeselectRowAt: (self.tableView.indexPathForSelectedRow)!)
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
            }
            self.tableView.reloadData()
            }, withCancel: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    
    
    @IBAction func addSweet(sender: AnyObject) {
        let sweetAlert = UIAlertController(title: "New Item", message: "Enter Your Item", preferredStyle: .alert)
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView(self.tableView, didDeselectRowAt: (self.tableView.indexPathForSelectedRow)!)
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
        sweetAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your Item"
            textField.autocapitalizationType = .words
        }
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {(UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text{
                
                    let sweet = Sweet(content: sweetContent, addedByUser: self.usersName)
                
                    let sweetRef = FIRDatabase.database().reference().child("Lists").child(self.path).child("list").child(sweetContent.lowercased())

                    sweetRef.setValue(sweet.toAnyObject())
                
            }
        
        }))
        
        sweetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            sweetAlert.dismiss(animated:false, completion: nil)
        }))
        
        self.present(sweetAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sweets.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listName
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath as IndexPath {
            AnyRowIsSelected = true
            rowIsSelected = true
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RefrigerdataCell
        
        if rowIsSelected == false {
        cell.backgroundColor = UIColor(r: 120, g: 220, b: 120)
        cell.item.textColor = UIColor.white
        cell.detail.textColor = UIColor.white
        
        cell.addSubview(coverView)
        coverView.addSubview(ownItButton)
        coverView.addSubview(checkButton)
        coverView.addSubview(deleteButton)
            
        coverView.leftAnchor.constraint(equalTo:cell.centerXAnchor, constant: -10).isActive = true
        coverView.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
        coverView.rightAnchor.constraint(equalTo:cell.rightAnchor).isActive = true
        coverView.heightAnchor.constraint(equalTo:cell.heightAnchor).isActive = true
        
        ownItButton.leftAnchor.constraint(equalTo:cell.centerXAnchor).isActive = true
        ownItButton.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
        ownItButton.widthAnchor.constraint(equalTo:cell.widthAnchor, multiplier: 1/7).isActive = true
        ownItButton.heightAnchor.constraint(equalTo:cell.heightAnchor, multiplier: 3/4).isActive = true
        
        checkButton.leftAnchor.constraint(equalTo:ownItButton.rightAnchor, constant: 2).isActive = true
        checkButton.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
        checkButton.rightAnchor.constraint(equalTo:deleteButton.leftAnchor, constant: -2).isActive = true
        checkButton.heightAnchor.constraint(equalTo:cell.heightAnchor, multiplier: 3/4).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo:cell.rightAnchor, constant: -2).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo:cell.centerYAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo:cell.widthAnchor, multiplier: 1/7).isActive = true
        deleteButton.heightAnchor.constraint(equalTo:cell.heightAnchor, multiplier: 3/4).isActive = true
        rowIsSelected = true
            
        }else{
            
            cell.backgroundColor = UIColor.white
            cell.item.textColor = UIColor.black
            cell.detail.textColor = UIColor.black
            coverView.removeFromSuperview()
            ownItButton.removeFromSuperview()
            checkButton.removeFromSuperview()
            deleteButton.removeFromSuperview()
            
 
            rowIsSelected = false
            tableView.deselectRow(at:indexPath as IndexPath, animated: true)
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
                cell.item.textColor = UIColor.black
                cell.detail.textColor = UIColor.black
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RefrigerdataCell
        
        
        coverView.removeFromSuperview()
        ownItButton.removeFromSuperview()
        checkButton.removeFromSuperview()
        deleteButton.removeFromSuperview()
        
 
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
            cell.item.textColor = UIColor.black
            cell.detail.textColor = UIColor.black
        }
        
        cell.backgroundColor = UIColor.white
        rowIsSelected = false
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(RefrigerdataCell.self, forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RefrigerdataCell
        let sweet = sweets[indexPath.row]
        
        
        cell.selectionStyle = .none
        
        tableView.deselectRow(at:indexPath as IndexPath, animated: true)
        cell.item.translatesAutoresizingMaskIntoConstraints = false
        cell.item.text = sweet.content
        cell.addSubview(cell.item)
        cell.item.leftAnchor.constraint(equalTo:cell.leftAnchor, constant: 24).isActive = true
        cell.item.bottomAnchor.constraint(equalTo:cell.centerYAnchor, constant: 5).isActive = true
        cell.item.rightAnchor.constraint(equalTo:cell.rightAnchor, constant: -2).isActive = true
        cell.item.topAnchor.constraint(equalTo:cell.topAnchor).isActive = true
        
        
        cell.detail.translatesAutoresizingMaskIntoConstraints = false
        cell.detail.font = cell.detail.font.withSize(10)
        
        
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
            cell.detail.text = "Added by: \(sweet.addedByUser!)"
            cell.item.textColor = UIColor.black
            cell.detail.textColor = UIColor.black
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
        cell.detail.leftAnchor.constraint(equalTo:cell.leftAnchor, constant: 24).isActive = true
        cell.detail.bottomAnchor.constraint(equalTo:cell.bottomAnchor).isActive = true
        cell.detail.rightAnchor.constraint(equalTo:cell.rightAnchor, constant: -2).isActive = true
        cell.detail.topAnchor.constraint(equalTo:cell.item.bottomAnchor).isActive = true
        
        return cell
    }
 
    func handleOwnIt(){
        let cell = self.tableView.cellForRow(at: (self.tableView.indexPathForSelectedRow)!) as! RefrigerdataCell
        var sweet = sweets[(self.tableView.indexPathForSelectedRow?.row)!]

        if sweet.owned == true {
            itemAlreadyOwned()
        }else{
            sweet.owned = true
            sweet.ownedBy = self.usersName
            
            FIRDatabase.database().reference().child("Lists").child(path).child("list").child(sweet.content.lowercased()).updateChildValues(["owned":sweet.owned, "ownedBy": sweet.ownedBy!], withCompletionBlock: { (err, ref) in
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
            let ownedAlert = UIAlertController(title: "Already Yours 😁", message: nil, preferredStyle: .actionSheet)
            ownedAlert.addAction(UIAlertAction(title: "Oh Yeah! 😅", style: .cancel, handler: { (UIAlertAction) in
                ownedAlert.dismiss(animated:true, completion: nil)
            }))
            self.present(ownedAlert, animated: true, completion: nil)
        }else{
            let ownedAlert = UIAlertController(title: "Item already owned 😅", message: nil, preferredStyle: .actionSheet)
            ownedAlert.addAction(UIAlertAction(title: "Fine!", style: .cancel, handler: { (UIAlertAction) in
                ownedAlert.dismiss(animated:true, completion: nil)
            }))
            self.present(ownedAlert, animated: true, completion: nil)
        }
        
    }

    func handleDelete(){
        let cell = self.tableView.cellForRow(at: (self.tableView.indexPathForSelectedRow)!) as! RefrigerdataCell
        let item = cell.item.text!
        let sweetAlert = UIAlertController(title: "Are you sure you want to delete \(item) from this list?", message: nil, preferredStyle: .alert)
        
        sweetAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(UIAlertAction) in
            
            
                let sweet = self.sweets[(self.tableView.indexPathForSelectedRow?.row)!]
                let sweetRef = FIRDatabase.database().reference().child("Lists").child(self.path).child("list").child(sweet.content.lowercased())
                self.tableView(self.tableView, didDeselectRowAt: (self.tableView.indexPathForSelectedRow)!)
                self.tableView.deselectRow(at: (self.tableView.indexPathForSelectedRow)!, animated: true)
            
            
                sweetRef.removeValue(completionBlock: { (err, ref) in
                    
                    if err != nil {
                        print(err)
                        return
                    }
                })
            
        }))
        
        sweetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            sweetAlert.dismiss(animated:false, completion: nil)
        }))
        
        self.present(sweetAlert, animated: true, completion: nil)
        
    }
    
    func handleCheck(){
        var sweet = sweets[(self.tableView.indexPathForSelectedRow?.row)!]
        
      if sweet.checked != true {
        sweet.checked = true
        FIRDatabase.database().reference().child("Lists").child(path).child("list").child(sweet.content.lowercased()).updateChildValues(["checked":sweet.checked], withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                
                return
            }
            
            
        })
      }else{
        sweet.checked = false
        FIRDatabase.database().reference().child("Lists").child(path).child("list").child(sweet.content.lowercased()).updateChildValues(["checked":sweet.checked], withCompletionBlock: { (err, ref) in
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
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitCondensed)
    }
    
}
