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
    let members: [String]?
    let lists: [String]?
    let itemRef:FIRDatabaseReference?
    
    init(name:String, members:[String], key:String = "", lists:[String]) {
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
        if let frigeMembers = snapshot.value!["members"] as? [String]{
            members = frigeMembers
        }else{
            members = []
        }
        if let frigeList = snapshot.value!["list"] as? [String]?{
            lists = frigeList
        }else{
            lists = nil
        }
        
    
    }
 
    func toAnyObject()-> AnyObject {
        return["name":name, "members": members!, "lists": lists!]
    }
}