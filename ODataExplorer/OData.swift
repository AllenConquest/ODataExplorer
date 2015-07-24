//
//  OData.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 24/03/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Alamofire
import SWXMLHash

enum URLStrings: String {
    case metadata = "/$metadata"
}

struct OData {
    
    enum Router: URLRequestConvertible {
        
        case Metadata(String)
        case Resource(String, String, [String:String])
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Metadata (let url):
                    return ("\(url)\(URLStrings.metadata.rawValue)", [:])
                case .Resource(let url, let resource, let params):
                    return ("\(url)/\(resource)", params)
                }
                }()
            
            let URL = NSURL(string: path)
            let URLRequest = NSURLRequest(URL: URL!)
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }

    }
}

