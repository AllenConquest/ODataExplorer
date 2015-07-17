//
//  Entity.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 16/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SWXMLHash

class Entity {
    
    typealias Property = (name: String, type: String, nullable: Bool)
    typealias NavigationProperty = (name: String, relationship: String, fromRole: String, toRole: String)
    
    let name: String?
    var key: [String]?
    var property: [Property]?
    var navigationProperty: [NavigationProperty]?
    // TODO Add all types of nodes and initialise them
    
    required init(xml: XMLIndexer) {
        
        self.name = xml.element?.attributes["Name"]
        
    }
}
