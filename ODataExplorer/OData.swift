//
//  OData.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 24/03/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Alamofire
import SWXMLHash

struct OData {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://live.energysys.com"
        
        case Metadata(String)
        case Resource(String, String, [String:String])
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Metadata (let asset):
                    return ("/odata/resource.svc/\(asset)/$metadata", [:])
                case .Resource(let asset, let resource, let params):
                    return ("/odata/resource.svc/\(asset)/\(resource)", params)
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }

    }
}

struct Schema {
    
    var namespace = ""
}

struct Metadata {
    
//    let schema =
    let xml: XMLIndexer
    var entities = [String:AnyObject]()
//    var entityType
//    var Association
//    var entityContainer

    internal func entityTypes(xml: XMLIndexer) -> [String:AnyObject] {
        
        for child in xml {
            if let entityType = child.element {
                if entityType.name == "EntityType" {
                    println("Entity: \(entityType.name) - attributes: \(entityType.attributes)")
                    if let key = entityType.attributes["Name"] {
                        
                        for propertyChild in child.children {
                            
                            if let property = propertyChild.element {
                                
                                //                            if prope
                            }
                            
                        }
                    }
                    
                    
                }
            }
        }
        return entities
    }
    
    func getEntities() -> [String:AnyObject] {
        return entities
    }
}

