//
//  Metadata.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 20/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SWXMLHash

class MetaData {
    
    let xml: XMLIndexer
    let schema: (xmlns: String?, namespace: String?)?
    var entities = [Entity]()
    // TODO add all MetaData types such as ComplexTypes, Associations
    
    init(xml: XMLIndexer) {
        
        self.xml = xml
        let schema = xml["edmx:Edmx"]["edmx:DataServices"]["Schema"][0] // There can be more than one schema
        let xmlns = schema.element?.attributes["xmlns"]
        let namespace = schema.element?.attributes["Namespace"]
        self.schema = (xmlns, namespace)
        
        let entityTypes = schema["EntityType"]
        for child in entityTypes {
            let entity = Entity(xml: child)
            self.entities.append(entity)
        }
        
    }

    struct Schema {
        
        var namespace = ""
    }
}

