//
//  ViewController.swift
//  MonkeyDemo
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bookUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("book", ofType: nil)!)
        let bookData = NSData(contentsOfURL: bookUrl)
        
        let castUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("casts", ofType: nil)!)
        let castsData = NSData(contentsOfURL: castUrl)
        let casts = Monkey.modelArray(castsData, clz: Cast.self) 
        print(casts)
        
        let book = Monkey.model(bookData, clz: Book.self) 
        NSLog("end")
        book?.images?.large
        
        let authors = book?.author
        authors?.forEach({ (author: String) -> () in
            print(author)
        })
        
        
        let tags = book?.tags
        tags?.forEach({ (tag: Tag) -> () in
            print(tag.title)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    
}

