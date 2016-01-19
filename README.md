# Monkey
The JSON Data / JSON Object  to Object Model Utils


#Example usage
Let's say we are dealing with JSON data about test object, where a record looks like this:

```json
{ 
    "test_object": {
        "id": 5,
        "title": "title",
        "is_new": false,
        "optional_notes": "optional_notes"
    }
}
```

To deserialize records to Swift object instances, create a class derived from ```Monkey``` and add properties matching the JSON properties you want to deserialize.

```swift
class TestObject : Monkey {
    var id:NSNumber!                          /// ! to indicate expected presence
    var title:String!                         /// ! to indicate expected presence
    var isNew:Bool = true /// property with default value
    var optionalNotes:String?                 /// ? to indicate optional value
}
```

Objects are deserialized from JSON objects or raw JSON data like so:

```swift
//Deserialize raw JSON data
let jsonData:NSData = getJSONDataFromSomewhere()
let aTestObject = TestObject(jsonData: jsonData)
print("The title of this comic book is \(aTestObject.title)")

//Deserialize a JSON dictionary
let jsonObject:NSDictionary = getJSONObjectFromSomewhere()
let anotherComicBook = ComicBook(jsonObject: jsonObject)
print("The title of this comic book is \(anotherComicBook.title)")
```

#Name matching
A JSON key counts as matching a Swift property or class name if the lower case versions, excluding underscores, of the two match. For example, this means that all pairs in the following list count as matches.

* ```someObject```
* ```SomeObject```
* ```someobject```
* ```some_object```
* ```Some_Object```

This matching method allows you to easily mix snake case and camel case.

#Root keys

##Default root key

```json
{ 
    "test_object": {
        "id": 5,
        "title": "title",
        "is_new": false,
        "optional_notes": "optional_notes"
    }
}
```

Here we don't need to provide a custom root key since the ```test_object ``` matches the class name ```TestObject ``` and is used by default.

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let aTestObject = TestObject(jsonData: jsonData)
```

##Custom root key
```json
{ 
    "main_object": {
        "id": 5,
        "title": "Captain Lolface",
        "is_new": false,
        "optional_notes": "Mint condition"
    },
    "other_object": {
        "id": 1
    }
}
```

In this case, it's necessary to provide the root key since it doesn't match the Swift class name.

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let a TestObject = TestObject(
jsonData: jsonData, 
rootKey: "main_object"
)
```

##Single root key
```json
{ 
    "main_object": {
        "id": 5,
        "title": "Captain Lolface",
        "is_new": false,
        "optional_notes": "Mint condition"
    }
}
```

If there is only a single key in the JSON dictionary and the corresponding value is a dictionary, then this dictionary is automatically deserialized and there's no need to provide a custom root key.

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let aTestObject = TestObject(jsonData: jsonData)
```

##No root key

```json
{
    "id": 5,
    "title": "Captain Lolface",
    "is_new": false,
    "optional_notes": "Mint condition"
}
```

If a custom root key is not provided and none of the keys match the Swift class name, the dictionary is deserialized as is. 

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let aTestObject = TestObject(jsonData: jsonData)
```

#Deserializing arrays

Monkey provides convenience methods for deserializing arrays of objects. The root key handling works as in the section above, except a plural ```s``` is appended before matching. 

##Default root key
```json
{
    "comic_books": [
   	     {
            "id": 10,
            "title": "My Little Lolface",
            "is_new": false
        },
        {
            "id": 13,
            "title": "Magic etc",
            "is_new": false
        }
	]
}
```

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let testObjects:[TestObject]? = TestObject.deserializeArray(jsonData: jsonData)
```

##Custom root key
```json
{
    "my_comic_books": [
        {
            "id": 10,
            "title": "My Little Lolface",
            "is_new": false
        },
        {
            "id": 13,
            "title": "Magic etc",
            "is_new": false
        }
    ],
    "another_array": [
        "item 1",
        "item 2"
    ]
}
```
```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let testObjects:[TestObject]? = TestObject.deserializeArray(
jsonData: jsonData
rootKey: "my_comic_books"
)
```

##Single root key
```json
{
    "my_comic_books": [
        {
            "id": 10,
            "title": "My Little Lolface",
            "is_new": false
        },
        {
            "id": 13,
            "title": "Magic etc",
            "is_new": false
        }
    ]
}
```

If there is only a single key in the JSON dictionary and the corresponding value is an array, then this array is automatically deserialized and there's no need to provide a custom root key.

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let testObjects:[TestObject]? = TestObject.deserializeArray(jsonData: jsonData)
```

##No root key
```json
[
    {
        "id": 10,
        "title": "My Little Lolface",
        "is_new": false
    },
    {
        "id": 13,
        "title": "Magic etc",
        "is_new": false
    }
]
```

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let testObjects:[TestObject]? = ComicBook.deserializeArray(jsonData: jsonData)
```


#Custom date formatters
If you have JSON data with date strings, you can provide custom date formatters to deserialize the date strings to ```NSDate``` objects.

Given this data JSON data

```json
{ 
    "point_in_time": {
        "date": 1453187501
    }
}
```

a custom date formatter is provided like this

```swift
class PointInTime : Monkey {
    var date:NSDate!

     override class func transfromDate(oldValue: AnyObject) -> AnyObject? {
        return NSDate(timeIntervalSince1970: oldValue.doubleValue)
    }
}
```
 

#Deserializing nested objects

Let's say you have this JSON data with nested comic book records you wish to deserialize:

```json
{ 
    "comic_book_nerd": {
        "comic_book": {
            "id": 5,
            "title": "Captain Lolface",
            "is_new": false,
            "optional_notes": "Mint condition"
        },
        "favorite_comic_book": {
	         "id": 10,
            "title": "My Little Lolface",
            "is_new": false
        }
    }
}
```

This is done by overriding ```didDeserializeDictionary```, like this:

```swift
class ComicBookNerd : Monkey {
    var comicBook:ComicBook!
    var favoriteComicBook:ComicBook!

    override func didDeserializeDictionary(dictionary:NSDictionary) {
    //if no custom root key is given, the object under the
    //root key "comic_book" will be deserialized
    comicBook = ComicBook(jsonObject: dictionary)

    //here we need to provide a custom root key
    favoriteComicBook = ComicBook(
            jsonObject: dictionary
            rootKey: "favorite_comic_book"
        )
    }
}
```

Deserializing works as usual

```swift
let jsonData:NSData = getJSONDataFromSomewhere()
let comicBookNerd = ComicBookNerd(jsonData: jsonData)
print("The nerd's favorit comic book is \(comicBookNerd.favoriteComicBook.title)")
```

#Custom property mapping

Sometimes, you will be working with JSON data where keys collide with Swift keywords or existing properites, for example ```class``` and ```description```. If changing the API is not an option, this is how you work around problematic keys like these

```json
{ 
    "comic_book_store": {
        "class": "World class",
        "description": "The best store ever."
    }
}
```

```swift
class : ComicBookStore {
    var storeClass:String!
    var storeDescription:String!

    //a set of key value pairs, where the key
    //is the name of the JSON property and 
    //the value is the name of the corresponding
    //swift property
    override var customPropertyMapping:[String:String]? {
        get {
            return [
                "class" : "storeClass",
                "description" : "storeDescription"
            ]
        }
    }
}
```

# License

Monkey is available under the MIT license. See the LICENSE file for more info.
