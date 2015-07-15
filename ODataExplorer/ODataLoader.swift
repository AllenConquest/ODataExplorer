//
//  ODataLoader.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 24/03/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Alamofire
import SWXMLHash

// Load OData document

let user = "allen.conquest@energysys.com"
let password = "Norman1070!"

let credential = NSURLCredential(user: user, password: password, persistence: .ForSession)

func getData() {
    
    Alamofire.request(OData.Router.Metadata("prdemo"))
        .authenticate(usingCredential: credential)
        .responseXML() {
        (request, response, XML, error) in
        
        if error == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                
                println(request)
                println(response)
                println(XML!.description)
                
                if (XML != nil) {
                    let xmlIndexer = XMLIndexer.Element(XML!)
                    let entity = xmlIndexer["edmx:Edmx"]["edmx:DataServices"]["Schema"]["EntityType"]
                    //                        let data = Metadata.entityTypes(entities)
                    for child in entity {
                        println(child.element?.attributes["Name"])
                        //                            getSchema()
                        //                            Metadata.entityTypes(child)
                        //                            getEntities()
                    }
                    
                }
                
//                let photoInfos = ((JSON as! NSDictionary).valueForKey("photos") as! [NSDictionary]).filter({ ($0["nsfw"] as! Bool) == false }).map { PhotoInfo(id: $0["id"] as! Int, url: $0["image_url"] as! String) }
//
//                // 9
//                self.photos.addObjectsFromArray(photoInfos)
//                
//                // 10
//                let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: 0) }
//                
//                // 11
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.collectionView!.insertItemsAtIndexPaths(indexPaths)
//                }
                
            }
        }
    }

//    
//    Alamofire.request(.GET, url)
//        .authenticate(usingCredential: credential)
//        .responseXML {(request, response, data, error) in
//            println(response)
//            if let indexerObj = data {
//                println(indexerObj.get().description)
//            }
//    }
}


func enumerate(indexer: XMLIndexer) {
    for child in indexer.children {
        println(child.element!.name)
        enumerate(child)
    }
}

// XML ResponseSerializer

extension Request {
    class func XMLResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if let data = data {
                var XMLSerializationError: NSError?
                let document = SWXMLHash.parse(data).element
                return (document, XMLSerializationError)
            } else {
                return (nil, nil)
            }
        }
    }
    public func responseXML(completionHandler: (NSURLRequest, NSHTTPURLResponse?, XMLElement?, NSError?) -> Void) -> Self {
        return response(queue: dispatch_get_main_queue(), serializer: Request.XMLResponseSerializer()) { (req, res, xml, error) -> Void in
            completionHandler(req, res, xml as? XMLElement, error)
        }
    }
}