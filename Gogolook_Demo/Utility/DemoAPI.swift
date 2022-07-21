//
//  DemoAPI.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/19.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class DemoAPI  {
    static var share = DemoAPI()
    
    var serverURL = "https://api.jikan.moe/v4/top/"

    let manager = Session.default
    
    func getTopAnime(type: String, filter: String, page: Int, limit: Int) -> Promise<listReturnData> {
        return Promise<listReturnData> { seal in
            let params = ["type": type,
                          "filter": filter,
                          "page": "\(page)",
                          "limit": "\(limit)"]
            let path = serverURL + "anime"
            print("getTopAnime serverURL:\(path)")
            print("getTopAnime params:\(params)")
            manager.request(path, method: .get, parameters: params)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        seal.fulfill(listReturnData(json: json))
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
        }
    }
    
    func getTopManga(type: String, filter: String, page: Int, limit: Int) -> Promise<listReturnData> {
        return Promise<listReturnData> { seal in
            let params = ["type": type,
                          "filter": filter,
                          "page": "\(page)",
                          "limit": "\(limit)"]
            let path = serverURL + "anime"
            print("getTopManga serverURL:\(path)")
            print("getTopManga params:\(params)")
            manager.request(path, method: .get, parameters: params)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        seal.fulfill(listReturnData(json: json))
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
        }
    }
}
