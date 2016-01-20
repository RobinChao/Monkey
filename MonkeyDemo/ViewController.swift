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
        
        
        if let jsonPath = jsonFilePath("json") {
            if let jsonData = NSData(contentsOfFile: jsonPath) {
                let model: Final = Final(jsonData: jsonData)
                print("model!.id: \(model.model!.id)")
                print("model!.name: \(model.model!.name)")
                print("model!.boolll: \(model.model!.boolll)")
                print("model!.date: \(model.model!.date)")
                print("model!.date: \(model.model!.array)")
                print("model!.date: \(model.model!.temps)")
                print("\n")
                print("inlineModel!.count: \(model.inlineModel!.count)")
                
                for  (index, inline) in model.inlineModel!.enumerate() {
                    print("\(index)_inline.Inlineid: \( inline.Inlineid)")
                    print("\(index)_inline.Inlinename: \( inline.Inlinename)")
                    print("\(index)_inline.boolll: \( inline.boolll)")
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    private func loadJsonfile(filename: String) -> AnyObject? {
        if let jsonPath = jsonFilePath(filename) {
            if let jsonData = NSData(contentsOfFile: jsonPath) {
                let jsonObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                return jsonObject
            }
        }
        return nil
    }
    
    private func jsonFilePath(filename: String) -> String? {
        var path = NSBundle(forClass: self.dynamicType).pathForResource(filename, ofType: nil)
        if path == nil {
            path = NSBundle(forClass: self.dynamicType).pathForResource(filename, ofType: "json")
        }
        return path
    }

    
}

