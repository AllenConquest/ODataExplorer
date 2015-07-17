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

class MetaData {
    
    let xml: XMLIndexer
    let schema: (xmlns: String?, namespace: String?)?
    var entities = [Entity]()
    // TODO add all MetaData types such as ComplexTypes, Associations

    required init(xml: XMLIndexer) {
        
        self.xml = xml
        let schema = xml["edmx:Edmx"]["edmx:DataServices"]["Schema"]
        let xmlns = schema.element?.attributes["xmlns"]
        let namespace = schema.element?.attributes["Namespace"]
        self.schema = (xmlns, namespace)
        
        let entityTypes = schema["EntityType"]
        for child in entityTypes {
            let entity = Entity(xml: child)
            self.entities.append(entity)
        }
        
    }
}

