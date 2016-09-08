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
    let members: [String : String]?
    let lists: [String : String]?
    let itemRef:FIRDatabaseReference?
    
    init(name:String, members:[String : String], key:String = "", lists:[String : String]) {
        self.key = key
        self.name = name
        self.members = members
        self.lists = lists
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
        if let frigeMembers = snapshot.value!["members"] as? [String : String]{
            members = frigeMembers
        }else{
            members = nil
        }
        if let frigeList = snapshot.value!["list"] as? [String : String]?{
            lists = frigeList
        }else{
            lists = nil
        }
        
    
    }
 
    func toAnyObject()-> [NSObject : AnyObject] {
        return["name":name, "members": members!, "lists": lists!]
    }
}