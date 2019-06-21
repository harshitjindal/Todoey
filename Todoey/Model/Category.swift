//
//  Category.swift
//  Todoey
//
//  Created by Harshit Jindal on 21/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
