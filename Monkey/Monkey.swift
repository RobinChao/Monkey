

import Foundation

final public class Monkey {
    //json object to model
    public class func model<T: NSObject>(json: AnyObject?, clz: T.Type) -> T?{
        let model = T()
        if let _ = json{
            if json is NSDictionary{
                model.setProperty(json)
                return model
            }else{
                debugPrint("error: reflect model need a dictionary json")
            }
        }
        return nil
    }
    
    public class func model<T: NSObject>(data: NSData?, clz: T.Type) -> T?{
        let model = T()
        if let _ = data{
            do{
                let json: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if json is NSDictionary{
                    model.setProperty(json)
                    return model
                }else{
                    debugPrint("error: reflect model need a dictionary json")
                }
            }catch{
                debugPrint("Serializat json error, \(error)")
            }
        }
        return nil
    }
    
    
    public class func modelArray<T: NSObject>(json: AnyObject?, clz: T.Type) -> [T]?{
        var modelArray = [T]()
        if let _ = json{
            if json is NSArray {
                for jsonObj in json as! NSArray{
                    let model = T()
                    model.setProperty(jsonObj)
                    modelArray.append(model)
                }
                return modelArray
            } else {
                debugPrint("error: reflect model need a array json")
            }
        }
        return nil
    }
    
    public static func modelArray<T: NSObject>(data: NSData?, clz: T.Type) -> [T]? {
        var modelArray = [T]()
        if let _ = data {
            do {
                let json: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if json is NSArray {
                    for jsonObj in json as! NSArray {
                        let model = T()
                        model.setProperty(jsonObj)
                        modelArray.append(model)
                    }
                    return modelArray
                } else {
                    debugPrint("error: reflect model need a array json")
                }
            } catch {
                debugPrint("Serializat json error, \(error)")
            }
        }
        return nil
    }
}