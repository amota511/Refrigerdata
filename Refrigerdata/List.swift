//
//  List.swift
//  Refrigerdata
//
//  Created by amota511 on 8/21/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import Foundation
import Firebase

struct List {
    
    let key:String!
    let name:String!
    //let items:[String]?
    let itemRef:FIRDatabaseReference?
    
    init(name:String, key:String = "") {
        self.key = key
        self.name = name
        
        self.itemRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let value = snapshot.value as? NSDictionary
        
        if let listName = value?["name"] as? String{
            name = listName
        }else{
            name = ""
        }
    }
 
}
