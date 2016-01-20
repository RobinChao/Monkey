 

import UIKit

class Movie: NSObject {
    var reviews_count: Int = 0
    var title: String?
    var share_url: String?
    var subtype: String?
    var images: Images?
    
    func setupReplaceObjectClass() -> [String : String] {
        return ["images": "Images"]
    }
}
