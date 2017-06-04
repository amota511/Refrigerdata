//
//  Sweet.swift
//  Refrigeradata
//
//  Created by amota511 on 8/13/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key:String!
    let content:String!
    var addedByUser:String!
    var owned:Bool!
    var ownedBy:String?
    var checked:Bool!
    let itemRef:FIRDatabaseReference?
    
    init(content:String, addedByUser:String, key:String = "", check:Bool = false, owned:Bool = false, ownedBy:String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.checked = false
        self.owned = false
        self.ownedBy = ""
        self.itemRef = nil
    }
    
    init(snapshot:FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        print(snapshot.value as Any)
        
        let value = snapshot.value as? NSDictionary
        //let username = value?["username"] as! String
        
        if let sweetUser = value?["addedByUser"] as? String{
            addedByUser = sweetUser
        }else{
            addedByUser = ""
        }
        
        if let sweetContent = value?["content"] as? String{
            content = sweetContent
        }else{
            content = ""
        }
        
        if let sweetOwned = value?["owned"] as? Bool{
            owned = sweetOwned
        }else{
            owned = false
        }
        if let sweetOwnedBy = value?["ownedBy"] as? String{
            ownedBy = sweetOwnedBy
        }else{
            ownedBy = ""
        }
        if let sweetChecked = value?["checked"] as? Bool{
            checked = sweetChecked
        }else{
            checked = false
        }
    }
    func toAnyObject()-> [String : AnyObject] {
        return["content": content as AnyObject, "addedByUser": addedByUser as AnyObject, "owned": owned as AnyObject, "ownedBy": ownedBy! as AnyObject, "checked": checked as AnyObject]
    }
}
