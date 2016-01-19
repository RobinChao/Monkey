//
//  DateObject.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

class DateObject: Monkey {
    var date: NSDate!
    
    override class func transfromDate(oldValue: AnyObject) -> AnyObject? {
        return NSDate(timeIntervalSince1970: oldValue.doubleValue)
    }
}