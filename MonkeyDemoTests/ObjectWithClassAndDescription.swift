//
//  ObjectWithClassAndDescription.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

class ObjectWithClassAndDescription : Monkey {
    
    override var customPropertyMapping: [String : String]? {
        return ["class" : "objectClass", "description" : "objectDescription"]
    }
    
    var objectClass:String?
    var objectDescription:String?
}
