 

import Foundation

final public class MonkeyForPlist {

    public static func model<T: NSObject>(plistName: String?, type: T.Type) -> T? {
        let plistPath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        if let _ = plistPath {
            let plistUrl = NSURL.fileURLWithPath(plistPath!)
            let json = NSDictionary(contentsOfURL: plistUrl)
            let model = T()
            if let _ = json {
                model.setProperty(json)
                return model
            }
        } else {
            debugPrint("error plist name")
        }
        return nil
    }
    
    public static func modelArray<T: NSObject>(plistName: String?, type: T.Type) -> [T]? {
        let plistPath = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        if let _ = plistPath {
            let json = NSArray(contentsOfURL: NSURL.fileURLWithPath(plistPath!))
            var modelArray = [T]()
            if let _ = json {
                for jsonObj in json! {
                    let model = T()
                    model.setProperty(jsonObj)
                    modelArray.append(model)
                }
                return modelArray
            }
        } else {
            debugPrint("error plist name")
        }
        return nil
    }

    
}