//
//  Article.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable{
    var id:Int?
    var title:String?
    var description: String?
    var category:Category?
    var createdDate: String?
    var image:String?
    init() {
        self.category = Category()
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id          <- map["ID"]
        title       <- map["TITLE"]
        description <- map["DESCRIPTION"]
        createdDate <- map["CREATED_DATE"]
        category    <- map["CATEGORY"]
        image       <- map["IMAGE"]
    }
}
class Category: Mappable{
    var id:Int?
    var name:String?
    init() {
        
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id      <- map["ID"]
        name    <- map["NAME"]
    }
}
