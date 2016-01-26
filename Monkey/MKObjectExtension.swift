 

import Foundation

 @objc
 protocol MonkeyProtocol {
    optional func setupReplacePropertyName() -> [String: String]
    optional func setupReplaceObjectClass() -> [String: String]
    optional func setupReplaceElementClass() -> [String: String]
 }
 
 extension NSObject: MonkeyProtocol {

     func setProperty(json: AnyObject!){
        //CHECK  PROTOCOL
        var replacePropertyName: [String : String]?
        var replaceObjectClass: [String : String]?
        var replaceElementClass: [String : String]?
        if self.respondsToSelector(Selector("setupReplacePropertyName")){
            let res = self.performSelector(Selector("setupReplacePropertyName"))
            replacePropertyName = res.takeUnretainedValue() as? [String : String]
        }
        if self.respondsToSelector(Selector("setupReplaceObjectClass")){
            let res = self.performSelector(Selector("setupReplaceObjectClass"))
            replaceObjectClass = res.takeUnretainedValue() as? [String : String]
        }
        if self.respondsToSelector(Selector("setupReplaceElementClass")){
            let res = self.performSelector(Selector("setupReplaceElementClass"))
            replaceElementClass = res.takeUnretainedValue() as? [String : String]
        }
        
        let mirror = Mirror(reflecting: self)
        for item in mirror.children {
            let key = item.label!
            
            if let value =  json!.valueForKey(key) as? NSNull {
                debugPrint("The key \(key)   value is \(value)")
            }else{
                self.setValue(json!.valueForKey(key), forKey: key)
            }
            
            // set sub model
            if let _ = replaceObjectClass {
                if replaceObjectClass!.keys.contains(key){
                    let type = replaceObjectClass![key]!
                    if let clz = NSClassFromString(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")!.description + "." + type ) as? NSObject.Type{
                        let obj = clz.init()
                        obj.setProperty(json.valueForKey(key))
                        self.setValue(obj, forKey: key)
                    }else{
                        debugPrint("setup replace object class with error name!");
                    }
                }
            }
            
            // set sub model array
            if let _ = replaceElementClass {
                if replaceElementClass!.keys.contains(key) {
                    let type = replaceElementClass![key]!
                    
                    if let clz = NSClassFromString(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")!.description + "." + type ) as? NSObject.Type{
                        if let subJsonArray = json!.valueForKey(key) as? NSArray {
                            var subModelArray = [NSObject]()
                            for subJson in subJsonArray {
                                let obj = clz.init()
                                obj.setProperty(subJson)
                                subModelArray.append(obj)
                            }
                            self.setValue(subModelArray, forKey: key)
                        }else{
                            debugPrint("setup replace object class with error name!");
                        }
                    }else{
                        debugPrint("setup replace object class with error name!");
                    }
                }
            }
        }
        
        // set replace property name
        if let _ = replacePropertyName{
            for key in replacePropertyName!.keys{
                if let value =  json!.valueForKey(key) as? NSNull {
                    debugPrint("The key \(key)   value is \(value)")
                }else{
                    self.setValue(json!.valueForKey(key), forKey: replacePropertyName![key]!)
                } 
            }
        }
    }
 }