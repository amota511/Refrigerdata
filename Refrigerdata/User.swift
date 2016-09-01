//
//  User.swift
//  Refrigeradata
//
//  Created by amota511 on 8/13/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    let uid: String
    let email:String
    
    init(userData:FIRUser) {
        
        uid = userData.uid
        if let mail = userData.providerData.first?.email {
            email = mail
        }else{
            email = ""
        }
    }
    init(uid:String, email:String){
        self.uid = uid
        self.email = email
    }
}