//
//  Monkey.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import Foundation

public class Monkey: NSObject{
    //自定义属性对照器
    public var customPropertyMapping: [String : String]? {
        return  nil
    }
    
    //MARK: -生命周期
    public required override init() {
        super.init()
    }
    
    //根据JSON数据构建解析对象
    public required init(jsonObject: AnyObject?, rootKey: String? = nil) {
        super.init()
        
        // 如果JSON Data 是字典
        if let dictionary = jsonObject as? NSDictionary {
            if let deserializeDictionary = deserializeDictionary(dictionary, rootKey: rootKey) {
                didDeserializeDictionary(deserializeDictionary)
            }
        }
    }
    //根据JSON Data数据构建解析对象
    public required init(jsonData: NSData? , rootKey: String? = nil) {
        super.init()
        
        if let jsonData = jsonData {
            // try to parse it to json
            let jsonObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            if let dictionary = jsonObject as? NSDictionary {
                if let deserializedictionary = deserializeDictionary(dictionary, rootKey: rootKey) {
                    didDeserializeDictionary(deserializedictionary)
                }
            }
        }
    }
    
    public func didDeserializeDictionary(dictionary:NSDictionary) {
        //override this method to provide additional custom deserialization,
        //for example of nested objects
        //可以重写此方法，自定义序列化
    }
    
    //MARK: Hooks for derived classes
    public class func transfromDate(oldValue: AnyObject) -> AnyObject? {
        return nil
    }
    
    
    //MAKR: -Singleton object deserialization
    public class func deserialize<T: Monkey>(jsonData: NSData?, rootKey: String? = nil) -> T? {
        if let jsonData = jsonData {
            if let jsonObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []){
                return deserialize(jsonObject, rootKey: rootKey)
            }
        }
        return nil
    }
    
    public class func deserialize<T: Monkey>(jsonObject: AnyObject?, rootKey: String? = nil) -> T? {
        if let jsonObject = jsonObject {
            if let objectToDeserialize = extractObjectToDeserialize(jsonObject, swiftClassName: NSStringFromClass(T), lookingForArray: false, rootKey: rootKey) {
                return T(jsonObject: objectToDeserialize)
            }
        }
        return nil
    }
    
    //MARK: - Array  deserialization
    public class func deserializeArray<T: Monkey>(jsonData: NSData?, rootKey: String? = nil) -> [T]? {
        if let jsonData = jsonData {
            if let jsonObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []){
                return deserializeArray(jsonObject, rootKey: rootKey)
            }
        }
        return nil
    }
    
    public class func deserializeArray<T: Monkey>(jsonObject: AnyObject?, rootKey: String? = nil) -> [T]? {
        if let jsonObject = jsonObject {
            let objectToDeserialize = Monkey.extractObjectToDeserialize(jsonObject, swiftClassName: NSStringFromClass(T), lookingForArray: true, rootKey: rootKey)
            
            if let array = objectToDeserialize as? [NSDictionary]{
                var result = [T]()
                for itemDictionary in array {
                    result.append(T(jsonObject: itemDictionary))
                }
                return result
            }
        }
        return nil
    }
    
    
    //MAKR:- Private Methods
    //解析字典中的数据值 ## important !!
    private func deserializeDictionary(dictionary: NSDictionary, rootKey: String? = nil) -> NSDictionary? {
        let objectToDeserialize =  Monkey.extractObjectToDeserialize(
            dictionary,
            swiftClassName: NSStringFromClass(self.dynamicType),
            lookingForArray: false,
            rootKey: rootKey
        )
        
        if let dictionaryToDeserialize = objectToDeserialize as? NSDictionary {
            var count: UInt32 = 0
            let properties : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(self.dynamicType, &count)
            
            validateCustomPropertyMapping()
            
            //looking fro matching properties for each key
            for key in dictionaryToDeserialize.allKeys {
                let keyString = key as! String
                let normalizedKeyString = keyString.stringByReplacingOccurrencesOfString("_", withString: "").lowercaseString
                
                let customTargetPropertyName = customPropertyMapping?[keyString]
                
                for var i: UInt32 = 0; i < count; i++ {
                    let property = properties[Int(i)]
                    
                    
                    let propertyName = String.fromCString(property_getName(property))
                    let propertyAttributes = String.fromCString(property_getAttributes(property))
                     
                    let normalizedPropertyName = propertyName!.lowercaseString
                    if normalizedPropertyName == normalizedKeyString || customTargetPropertyName == propertyName {
//                        print("found key \(keyString) matching property \(propertyName)")
                        var value: AnyObject? = dictionaryToDeserialize.objectForKey(key)
                        if let _ = value as? NSNull {
                            value = nil
                        }
                        
                        if propertyAttributes?.rangeOfString("\"NSDate\"") != nil {
                            //this is an NSDate
                            if  let willEvoValue = value {
                                if  let transfromValue = self.dynamicType.transfromDate(willEvoValue) {
                                    value = transfromValue
                                }
                            }
                        }
                        
                        if let customTargetPropertyName = customTargetPropertyName {
                            setValue(value, forKey: customTargetPropertyName as String)
                        }else{
                            setValue(value, forKey: propertyName! as String)
                        }
                        break
                    }
                }
            }
            return dictionaryToDeserialize
        }
        return nil
    }
    
    //提取对象并进行反序列化 ## important !!
    private class func extractObjectToDeserialize(sourceData: AnyObject, swiftClassName: String, lookingForArray: Bool, rootKey: String? = nil) -> AnyObject? {
//        print("Swift class Name: \(swiftClassName)")
        if let dictionary = sourceData as? NSDictionary {
//            print("WARNING:   SourceData is Dictionary!!!")
            //sourceData  is Dictionary
            for key in dictionary.allKeys {
                if let keyString = key as? String {
                    var keyMatch = false
                    if let rootKey = rootKey {
                        keyMatch = keyString == rootKey
                    }else{
                        keyMatch = Monkey.keyMatchesClassName(keyString, swiftClassName: swiftClassName, plural: lookingForArray)
                    }
                    if keyMatch {
                        if let value = dictionary.valueForKey(keyString) {
                            return value
                        }
                    }
                }
            }
            
            if rootKey != nil {
//                print("WARNING:   Has custom root key!  will  extract after")
                return nil
            }
            
            //仅有一组数据的字典，表明其key只有一个
            if dictionary.count == 1 {
                let onlyValue = dictionary.valueForKey(dictionary.allKeys.first as! String)
                
                if lookingForArray {
                    if let _ = onlyValue as? NSArray {
                        return onlyValue
                    }
                }else{
                    if let _ = onlyValue as? NSDictionary {
                        return onlyValue
                    }
                }
            }
            //如果字典中没有子字典被发现，则这个字典已经是最终可被反序列化的结果
            return dictionary
        }else if let array = sourceData as? NSArray {
//            print("WARNING:   SourceData is Array!!!")
            //如果是数组，可被反序列化
            return array
        }
        
        //如果非字典或非数组，则不能被反序列化
        // TODO:  这里可以根绝sourceData的类型，再进行是否字符串的判断
        return nil
    }
    
    
    // 键值对照
    // 需要去除Swift中生成的 _ ，并进行小写转换， 再进行对比
    private class func keyMatchesClassName(key: String, swiftClassName: String, plural: Bool) -> Bool {
        //转换类似类型 some_type_name 到 sometypename
        let normalizedKey: String = key.stringByReplacingOccurrencesOfString("_", withString: "").lowercaseString
        //转换类似类型 SomeTypeName 到 sometypename
        let lastPartOfSwiftClassName = (swiftClassName as String).componentsSeparatedByString(".").last!
        let normalizedClassName = lastPartOfSwiftClassName.lowercaseString.stringByAppendingString(plural ? "s" : "")
        
        // compare
        return normalizedClassName == normalizedKey
    }
    
    //验证属性对照器合法性
    //方法：检验自定义属性对照表中，是否有相同的value对应多个key
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
}