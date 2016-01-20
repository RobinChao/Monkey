 

import UIKit

class Item: NSObject {
    var username: String?
    var index: Int = 0
    var type: String?
    var users: Array<User>?
    
    func setupReplaceElementClass() -> [String : String] {
        return ["users": "User"]
    }
}
