//
//  RequestConfiguraton.swift
//
//  Created by Mohammed Sami on 10/3/18.
//  Copyright © 2018 Mohammed Sami. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - Enumurations

enum RequestSource {
    case production
    case test
}

//MARK: - Custom data types

class RequestConfiguraton {
    
    //MARK: - Properties
    var method: HTTPMethod
    var mode: Mode = Mode.development
    var endPoint: Endpoint
    var parametres: [String:String] = [String:String]()
    var headers: [String:String] = [String:String]()
    var completeURL: String {
        return mode == Mode.development ? Constants.debugBaseURL + endPoint.rawValue : Constants.productionBaseURL + endPoint.rawValue
    }
    var files: [File]?
    
    init(method: HTTPMethod,endPoint: Endpoint,params: [String:String],headers: [String: String],files: [File]) {
        self.headers["Accept"] = "application/json"
        self.method = method
        self.endPoint = endPoint
        self.parametres.combine(withOther: params)
        self.headers.combine(withOther: headers)
        self.files = files
    }
    
    init(method: HTTPMethod,endPoint: Endpoint,params: [String:String],files: [File]) {
        self.headers["Accept"] = "application/json"
        self.method = method
        self.endPoint = endPoint
        self.parametres.combine(withOther: params)
        self.files = files
    }
    
    init(method: HTTPMethod,endPoint: Endpoint,params: [String:String]) {
        self.headers["Accept"] = "application/json"
        self.method = method
        self.endPoint = endPoint
        self.parametres.combine(withOther: params)
    }
    
}


