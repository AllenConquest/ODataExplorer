//
//  Entity.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 16/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SWXMLHash

struct Entity {
    
    typealias NavigationProperty = (name: String, relationship: String, fromRole: String, toRole: String)
    
    let name: String?
    var key: [String]?
    var property = [Property]()
    //var navigationProperty = [NavigationProperty]()
    // TODO Add all types of nodes and initialise them
    
    init(xml: XMLIndexer) {
        
        self.name = xml.element?.attributes["Name"]
        
        let properties = xml["Property"]
        for child in properties {
            let property = Property(xml: child)
            self.property.append(property)
        }
    }

    func convertToArray() -> [AnyObject] {
        
        var output = [AnyObject]()
        for p in property {
            output.append(p.name!)
        }
        return output
    }

}
