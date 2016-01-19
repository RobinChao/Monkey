//
//  TestObject.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation 

class TestObject : Monkey {
    
    override var customPropertyMapping: [String : String]? {
        return [
            "sdfs" : "sdfsdf"
        ]
    }
    
    var id:NSNumber!
    var name:String!
}