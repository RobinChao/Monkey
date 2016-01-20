 

import UIKit

class User: NSObject {
    var avatar: String?
    var avatar_large: String?
    var link: String?
    var desc: String?
    
    func setupReplacePropertyName() -> [String : String] {
        return ["description": "desc"]
    }
}
