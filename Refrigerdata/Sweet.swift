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
    let addedByUser:String!
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
        
        if let sweetContent = snapshot.value!["content"] as? String{
            content = sweetContent
        }else{
            content = ""
        }
        if let sweetUser = snapshot.value!["addedByUser"] as? String{
            addedByUser = sweetUser
        }else{
            addedByUser = ""
        }
        if let sweetOwned = snapshot.value!["owned"] as? Bool{
            owned = sweetOwned
        }else{
            owned = false
        }
        if let sweetOwnedBy = snapshot.value!["ownedBy"] as? String{
            ownedBy = sweetOwnedBy
        }else{
            ownedBy = ""
        }
        if let sweetChecked = snapshot.value!["checked"] as? Bool{
            checked = sweetChecked
        }else{
            checked = false
        }
    }
    func toAnyObject()-> AnyObject {
        return["content":content, "addedByUser":addedByUser, "owned":owned, "ownedBy":ownedBy!, "checked":checked]
    }
}
