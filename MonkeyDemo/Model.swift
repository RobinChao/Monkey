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
    
    
    override class func transfromDate(oldValue: AnyObject) -> AnyObject? {
        return NSDate(timeIntervalSince1970: oldValue.doubleValue)
    }
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
        model = Model(jsonObject: dictionary, rootKey: "comic_book")
        inlineModel = InlineModel.deserializeArray(dictionary, rootKey:"some_other_object")
    }

}