//
//  Frige.swift
//  Refrigerdata
//
//  Created by amota511 on 8/21/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Frige {
    
    let key:String!
    let name:String!
    let members:User
    let list: [List]?
    let itemRef:FIRDatabaseReference?
    
    init(name:String, members:User, key:String = "", list:[List]?) {
        self.key = key
        self.name = name
        self.members = members
        self.list = list
        self.itemRef = nil
    }
    
    init(snapshot:FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let frigeName = snapshot.value!["name"] as? String{
            name = frigeName
        }else{
            name = ""
        }
        if let frigeMembers = snapshot.value!["members"] as? User{
            members = frigeMembers
        }else{
            members = User(uid: "hey", email: ".com")
        }
        if let frigeList = snapshot.value!["list"] as? [List]?{
            list = frigeList
        }else{
            list = nil
        }
        
    
    }
 
    func toAnyObject()-> AnyObject {
        return["name":name,]
    }
}