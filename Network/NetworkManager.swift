//
//  NetworkManager.swift
//
//  Created by Mohammed Sami on 11/3/18.
//  Copyright © 2018 Mohammed Sami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    func callApiOnWebServiceWithRawData(config: RequestConfiguraton,afterRequest:@escaping(JSON)->(),onFail:@escaping (NError)->()){
        Alamofire.request(config.completeURL,method: config.method,parameters: config.parametres,encoding: JSONEncoding.default,headers: config.headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                afterRequest(json)
            case .failure(_):
                onFail(NError.ConnectionError)
            }
        }
    }
    
    func callApiOnWebServiceWithFormData(config: RequestConfiguraton,afterRequest:@escaping(JSON)->(),onFail:@escaping (NError)->()){
        Alamofire.request(config.completeURL,method: config.method,parameters: config.parametres,headers: config.headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let statusCode = response.response!.statusCode
                let json = JSON(value)
                print("\(json)")
                if statusCode < 300{
                    let json = JSON(value)
                    afterRequest(json)
                }else{
                    let errorMsgs = json["errors"]
                    var errorMsg = ""
                    for (_,value) in errorMsgs{
                        errorMsg = value[0].stringValue
                        break
                    }
                    onFail(NError.ServerError(code: statusCode, reason: errorMsg))
                }
            case .failure(let _):
                onFail(NError.ConnectionError)
            }
        }
    }

    
    func callApiOnWebServiceWithUploadedData(config: RequestConfiguraton,afterRequest:@escaping()->(),onFail:@escaping (NError)->()){
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            for (key,value) in config.parametres {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            if let files = config.files{
                for file in files{
                    multipartFormData.append(file.path!, withName: file.name)
                    
                }
            }
        }, to: config.completeURL,method: .post, headers: config.headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON { response in
                    print(response.result.value!)
                    let statusCode = response.response!.statusCode
                    if statusCode < 300{
                        afterRequest()
                    }else{
                        let json = JSON(response.result.value!)
                        let errorMsgs = json["errors"]
                        var errorMsg = ""
                        for (_,value) in errorMsgs{
                            errorMsg = value[0].stringValue
                            break
                        }
                        onFail(NError.ServerError(code: statusCode, reason: errorMsg))
                    }
                    
                }
                break
            case .failure(let _):
                onFail(NError.ConnectionError)
                break
            }
        })
    }
    
    func downloadFile(url: String,afterRequest:@escaping(Data)->(),onFail:@escaping (NError)->()){
        Alamofire.request("\(url)").responseData { response in
            if let data = response.result.value {
                afterRequest(data)
            }else{
                onFail(NError.ConnectionError)
            }
        }
    }

}

