//
//  ODataLoader.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 24/03/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import InAppSettingsKit

// Load OData document


func getData(asset: String, completionHandler: (XMLElement?, NSError?) -> Void) {
    
    processDefaultSettings()
    let path = getBaseURL()
    let credentials = getCredentialsFromConfiguration()
    
    Alamofire.request(OData.Router.Metadata(path))
        .authenticate(usingCredential: credentials)
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

func getCredentialsFromConfiguration() -> NSURLCredential
{
    let myUsername = IASKSettingsStoreUserDefaults().objectForKey("es_username") as? String
    let myPassword = KeychainService.loadToken()
    if let myUser = myUsername {
        let myCredentials = NSURLCredential(user: myUser, password: myPassword! as String, persistence: NSURLCredentialPersistence.ForSession)
        return myCredentials
    }
    return NSURLCredential()
}

// Get URL from settings
func getBaseURL() -> String {
    if let url = IASKSettingsStoreUserDefaults().objectForKey("es_url") as? String {
        return url
    } else {
        let appDefaults = ["es_url": "https://live.energysys.com/odata/resource.svc"]
        IASKSettingsStoreUserDefaults().defaults.registerDefaults(appDefaults)
        return IASKSettingsStoreUserDefaults().objectForKey("es_url") as! String
    }
}

func processDefaultSettings() {
    
    let defaults = IASKSettingsStoreUserDefaults().defaults
    
    // settings files to process
    var preferenceFiles = [String]()

    // begin with Root file
    preferenceFiles.append("Root")

    // as other settings files are discovered will be added to preferencesFiles
    while !preferenceFiles.isEmpty {
        
        // init IASKSettingsReader for current settings file
        let file = preferenceFiles.last
        let settingsReader = IASKSettingsReader(file: file)
        preferenceFiles.removeLast()
        
        // extract preference specifiers
        if let preferenceSpecfiers = settingsReader.settingsDictionary[kIASKPreferenceSpecifiers] as? NSArray {
        
            // process each specifier in the current settings file
            for specifier in preferenceSpecfiers {
                
                println(specifier.debugDescription)
                // get type of current specifier
                let type = specifier[kIASKType] as! String
                
                // need to check child pane specifier for additional file
                if type == kIASKPSChildPaneSpecifier {
                    preferenceFiles.append(specifier[kIASKFile] as! String)
                }
                else {
                    // check if current specifier has a default value
                    if let defaultValue = specifier[kIASKDefaultValue] as AnyObject? {
                        
                        // get key from specifier and current stored preference value
                        if let key = specifier[kIASKKey] as? String {
                            
                            if let value = defaults.objectForKey(key) {
                                // Nothing to do - already set
                            }
                            else {
                                let appDefaults = [key: defaultValue]
                                defaults.registerDefaults(appDefaults)
                            }
                        }
                    }
                }
            }
        }
        // synchornize stored preference values
        defaults.synchronize()
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
                
                return (document.element, XMLSerializationError)
            } else {
                return (nil, nil)
            }
        }
    }
    func responseXML(completionHandler: (NSURLRequest, NSHTTPURLResponse?, XMLElement?, NSError?) -> Void) -> Self {
        return response(queue: dispatch_get_main_queue(), serializer: Request.XMLResponseSerializer()) { (req, res, metaData, error) -> Void in
            completionHandler(req, res, metaData as? XMLElement, error)
        }
    }
}