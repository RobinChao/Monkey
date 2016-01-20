//
//  Model.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation


class Model: Monkey {
    
    var id:NSNumber!
    var name:String!
    var boolll: Bool = false
    var date: NSDate!
    var array: [String]?
    var temps: [Temp]?

    override class func objectClassInArray() ->  [String : AnyClass]? {
        return ["temps" : Temp.self]
    }
    
    override class func transfromDate(oldValue: AnyObject) -> AnyObject? {
        return NSDate(timeIntervalSince1970: oldValue.doubleValue)
    }
}

class Temp: Monkey {
    var id: String!
    var name: String!
}

class InlineModel: Monkey {
    var Inlineid:NSNumber!
    var Inlinename:String!
    var boolll: Bool = false
    
    override var customPropertyMapping: [String : String]? {
        return [
            "id" : "Inlineid",
            "name" : "Inlinename"
        ]
    }
}

class Final: Monkey {
    var model: Model?
    var inlineModel: [InlineModel]?
    
    override func didDeserializeDictionary(dictionary: NSDictionary) {
        model = Model(jsonObject: dictionary, rootKey: "main_object")
        inlineModel = InlineModel.deserializeArray(dictionary, rootKey:"inlineObjects")
    }
}