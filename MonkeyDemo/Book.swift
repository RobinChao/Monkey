 

import UIKit

class Book: NSObject {
    var tt: String?
    var pubdate: String?
    var image: String?
    var binding: String?
    var pages: String?
    var alt: String?
    var id: String?
    var publisher: String?
    var summary: String?
    var price: String?
    var images: Images?
    var author: [String]?
    var tags: Array<Tag>?
    
    func setupReplacePropertyName() -> [String : String] {
        return ["title": "tt"]
    }
    
    func setupReplaceObjectClass() -> [String : String] {
        return ["images": "Images"]
    }
    
    func setupReplaceElementClass() -> [String : String] {
        return ["tags": "Tag"]
    }
}
