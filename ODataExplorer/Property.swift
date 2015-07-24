//
//  Property.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 19/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SWXMLHash

class Property {
    
    let name: String?
    let type: String?
    let maxLength: Int?
    let fixedLength: Bool?
    let nullable: Bool?
    let unicode: Bool?
    let xmlns: String?
    let storeGeneratedPattern: String?
    let precision: Int?
    let scale: Int?
    
    required init(xml: XMLIndexer) {
        
        self.name = xml.element?.attributes["Name"]
        self.type = xml.element?.attributes["Type"]
        self.maxLength = xml.element?.attributes["MaxLength"]?.toIntOrMax()
        self.fixedLength = xml.element?.attributes["FixLength"]?.toBool()
        self.nullable = xml.element?.attributes["Nullable"]?.toBool()
        self.unicode = xml.element?.attributes["Unicode"]?.toBool()
        self.xmlns = xml.element?.attributes["xmlns"]
        self.storeGeneratedPattern = xml.element?.attributes["StoreGeneratedPattern"]
        self.precision = xml.element?.attributes["Precision"]?.toInt()
        self.scale = xml.element?.attributes["Scale"]?.toInt()
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

extension String {
    func toIntOrMax() -> Int? {
        if self.toInt() != nil {
            return self.toInt()
        } else if self.lowercaseString == "max" {
            return -1
        } else {
            return nil
        }
    }
}