//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


public var customPropertyMapping: [String : String]? {
    return [
        "class" : "objectClass",
        "description" : "objectClass"
    ]

}

private func validateCustomPropertyMapping() {
    if let customPropertyMapping = customPropertyMapping {
        var uniqueValues = [String : String]()
        var nonUniqueValues = [String]()
        for value in customPropertyMapping.values {
            if  uniqueValues[value] != nil {
                //non unique!
                if !nonUniqueValues.contains(value){
                    nonUniqueValues.append(value)
                }
            }else{
                uniqueValues[value] = value
            }
        }
        if nonUniqueValues.count > 0 {
            print("WARNING: found property mapping with \(nonUniqueValues.count) non-unique values")
        }
    }
}

validateCustomPropertyMapping()