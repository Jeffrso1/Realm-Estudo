//
//  Contact.swift
//  RealmEstudo
//
//  Created by Jefferson Silva on 29/10/21.
//

import Foundation
import RealmSwift

// All classes that will work with Realm need to inherit from Object.
class Contact: Object {
    
    // When working with realm, all properties of our class need to conform to "@objc dynamic" so Realm can use them with obj-c functions.
    @objc dynamic var name = ""
    @objc dynamic var phone = ""
    
    // The _id object works as a identifier to Real, so every instance of Contact class is differentiable.
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    convenience init(name: String, phone: String) {
        self.init()
        self.name = name
        self.phone = phone
    }
    
    // The function below is used to determine which propertie will be used as a identifier to our class' instances.
    override static func primaryKey() -> String {
        return "_id"
    }
}
