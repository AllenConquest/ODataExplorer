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

func getData(completionHandler: (MetaData?, NSError?) -> Void) {
    
    Alamofire.request(OData.Router.Metadata("prdemo"))
        .authenticate(usingCredential: credential)
        .responseXML() {
        (request, response, metaData, error) in
        
            if let anError = error
            {
                completionHandler(nil, error)
                return
            }
            completionHandler(metaData, nil)
    }
}

// XML ResponseSerializer

extension Alamofire.Request {
    class func XMLResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if let data = data {
                var XMLSerializationError: NSError?
                let document = SWXMLHash.parse(data)
                
                let metaData = MetaData(xml: document)
                
                return (metaData, XMLSerializationError)
            } else {
                return (nil, nil)
            }
        }
    }
    func responseXML(completionHandler: (NSURLRequest, NSHTTPURLResponse?, MetaData?, NSError?) -> Void) -> Self {
        return response(queue: dispatch_get_main_queue(), serializer: Request.XMLResponseSerializer()) { (req, res, metaData, error) -> Void in
            completionHandler(req, res, metaData as? MetaData, error)
        }
    }
}