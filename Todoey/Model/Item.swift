//
//  Item.swift
//  Todoey
//
//  Created by Harshit Jindal on 21/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var status: Bool = false
    @objc dynamic var dateModified: Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
