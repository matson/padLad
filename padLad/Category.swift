//
//  Category.swift
//  padLad
//
//  Created by Tracy Adams on 6/19/23.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
    
    
    
    
}
