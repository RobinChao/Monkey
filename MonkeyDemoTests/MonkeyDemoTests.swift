//
//  MonkeyDemoTests.swift
//  MonkeyDemoTests
//
//  Created by Robin on 1/19/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import XCTest
@testable import MonkeyDemo

class MonkeyDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //MARK: Invalid data tests
    func testArrayWithNilData() {
        let jsonData:NSData? = nil
        let jsonObject:AnyObject? = nil
        
        let testObjects1:[TestObject]? = TestObject.deserializeArray(jsonData)
        XCTAssert(testObjects1 == nil)
        let testObjects2:[TestObject]? = TestObject.deserializeArray(jsonObject)
        XCTAssert(testObjects2 == nil)
    }
    
    func testArrayWithInvalidData() {
        let xmlString = "<hello>zup?</hello>" as NSString
        
        let invalidData:NSData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)!
        let testObjects:[TestObject]? = TestObject.deserializeArray(invalidData)
        XCTAssert(testObjects == nil)
    }
    
    func testObjectWithNullData() {
        let testObject1 = TestObject(jsonData: nil)
        XCTAssert(testObject1.id == nil)
        
        let testObject2 = TestObject(jsonObject: nil)
        XCTAssert(testObject2.id == nil)
        
        let testObject3:TestObject? = TestObject.deserialize(nil)
        XCTAssert(testObject3 == nil)
    }
    
    func testObjectWithInvalidData() {
        let xmlString = "<hello>zup?</hello>" as NSString
        let invalidData:NSData = xmlString.dataUsingEncoding(NSUTF8StringEncoding)!
        let testObject = TestObject(jsonData: invalidData)
        XCTAssert(testObject.id == nil)
        
        let testObject3:TestObject? = TestObject.deserialize(invalidData)
        XCTAssert(testObject3 == nil)
    }
    
    //MARK: Single TestObject tests
    func testValidObjectWithCustomRootKeyAndExtraProperty() {
        let filename = "valid_object_custom_root_extra_property"
        let rootKey = "custom_root_key"
        
        testObjectWithAllConstructors(filename, customRootKey: rootKey) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: rootKey) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    func testValidObjectWithCustomRootKey() {
        let filename = "valid_object_custom_root"
        let rootKey = "custom_root_key"
        
        testObjectWithAllConstructors(filename, customRootKey: rootKey) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: rootKey) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    func testValidObjectWithImplicitRootKey() {
        let filename = "valid_object_custom_root"
        
        testObjectWithAllConstructors(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    func testValidObjectWithCustomRootKeyShouldNotLoadWithoutKey() {
        
        let filename = "valid_object_custom_root_extra_property"
        
        testObjectWithAllConstructors(filename, customRootKey: nil) {
            testObject in
            self.validateInvalidDeserializedObject(testObject)
        }
    }
    
    func testValidObjectWithDefaultRootKeyAndExtraProperty() {
        let filename = "valid_object_default_root_extra_property"
        
        testObjectWithAllConstructors(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    func testValidObjectWithDefaultRootKey() {
        let filename = "valid_object_default_root"
        
        testObjectWithAllConstructors(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    func testValidObjectWithInvalidRootKey() {
        let filename = "valid_object_default_root"
        let rootKey = "lolz"
        
        testObjectWithAllConstructors(filename, customRootKey: rootKey) {
            testObject in
            self.validateInvalidDeserializedObject(testObject)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: rootKey) {
            testObject in
            XCTAssert(testObject == nil)
        }
    }
    
    func testValidObjectWithoutRootKey() {
        let filename = "valid_object_no_root"
        
        testObjectWithAllConstructors(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
        
        testObjectWithAllDeserializeHelpers(filename, customRootKey: nil) {
            testObject in
            self.validateDeserializedObject(testObject, expectedId: 1)
        }
    }
    
    //MARK: TestObject array tests
    func testValidArrayWithCustomRootKeyAndExtraProperty() {
        let jsonObject = loadJsonfile("valid_array_custom_root_extra_property")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject, rootKey: "custom_root_key") {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    func testValidArrayWithCustomRootKey() {
        let jsonObject = loadJsonfile("valid_array_custom_root")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject, rootKey: "custom_root_key") {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    func testValidArrayWithImplicitRootKey() {
        let jsonObject = loadJsonfile("valid_array_custom_root")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject, rootKey: nil) {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    func testValidArrayWithCustomRootKeyShouldNotLoadWithoutKey() {
        let jsonObject = loadJsonfile("valid_array_custom_root_extra_property")
        let testObjects:[TestObject]? = TestObject.deserializeArray(jsonObject)
        XCTAssert(testObjects == nil)
    }
    
    func testValidArrayWithDefaultRootKeyAndExtraProperty() {
        let jsonObject = loadJsonfile("valid_array_default_root_extra_property")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject) {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    func testValidArrayWithDefaultRootKey() {
        let jsonObject = loadJsonfile("valid_array_default_root_extra_property")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject) {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    func testValidArrayWithoutRootKey() {
        let jsonObject = loadJsonfile("valid_array_no_root")
        if let testObjects:[TestObject] = TestObject.deserializeArray(jsonObject) {
            validateDeserializedArray(testObjects)
        }
        else {
            XCTFail("Failed to deserialize array")
        }
    }
    
    
    //MARK: Custom property mapping test
    func testCustomPropertyMapping() {
        let jsonObject = loadJsonfile("problematic_keys")
        let object = ObjectWithClassAndDescription(jsonObject: jsonObject)
        XCTAssert(object.objectClass == "The class")
        XCTAssert(object.objectDescription == "The description")
    }
    
    //MARK: Test helpers
    private func testObjectWithAllConstructors(jsonFileName:String, customRootKey: String?, callback:(TestObject) -> Void) {
        if let jsonPath = jsonFilePath(jsonFileName) {
            if let jsonData = NSData(contentsOfFile: jsonPath) {
                let jsonObject = try? NSJSONSerialization.JSONObjectWithData(
                    jsonData,
                    options: []
                )
                
                //test json data constructor
                let testObjectFromJsonData = TestObject(
                    jsonObject: jsonObject,
                    rootKey: customRootKey
                )
                callback(testObjectFromJsonData)
                
                //test json object constructor
                let testObjectFromJsonObject = TestObject(
                    jsonObject: jsonObject,
                    rootKey: customRootKey
                )
                callback(testObjectFromJsonObject)
            }
            else {
                XCTFail("Failed to parse json file '\(jsonFileName)'")
            }
        }
        else {
            XCTFail("Failed to open json file '\(jsonFileName)'")
        }
    }
    
    private func testObjectWithAllDeserializeHelpers(jsonFileName:String, customRootKey: String?, callback:(TestObject?) -> Void) {
        if let jsonPath = jsonFilePath(jsonFileName) {
            if let jsonData = NSData(contentsOfFile: jsonPath) {
                let jsonObject = try? NSJSONSerialization.JSONObjectWithData(
                    jsonData,
                    options: []
                )
                
                //test deserialization helpers
                let testObjectFromJsonDataHelper:TestObject? = TestObject.deserialize(jsonData, rootKey: customRootKey)
                callback(testObjectFromJsonDataHelper)
                
                let testObjectFromJsonObjectHelper:TestObject? = TestObject.deserialize(jsonObject, rootKey: customRootKey)
                callback(testObjectFromJsonObjectHelper)
            }
            else {
                XCTFail("Failed to parse json file '\(jsonFileName)'")
            }
        }
        else {
            XCTFail("Failed to open json file '\(jsonFileName)'")
        }
    }
    
    
    //MARK:  test helpers
    private func validateDeserializedObject(object:TestObject?, expectedId:Int) {
        if let object = object {
            XCTAssert(object.id?.integerValue == expectedId)
            XCTAssert(object.name == "The name")
        }
        else {
            XCTAssert(false, "failed to validate nil object")
        }
    }
    
    private func validateInvalidDeserializedObject(object:TestObject) {
        XCTAssert(object.id == nil)
        XCTAssert(object.name == nil)
    }

    
    private func validateDeserializedArray(objects: [TestObject]) {
        XCTAssert(objects.count == 2)
        for i in 0..<objects.count {
            let object = objects[i]
            validateDeserializedObject(object, expectedId: i + 1)
        }
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
