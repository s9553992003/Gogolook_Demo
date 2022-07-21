//
//  animeReturnData.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/19.
//

import UIKit
import SwiftyJSON

struct listReturnData {
    var pagination: paginationData = paginationData()
    var listArray: [listData] = []

    init() {
        pagination = paginationData()
        listArray = []
    }
    
    init(json: JSON) {
        if json != JSON.null {
            pagination = paginationData(json: json["pagination"])
            if let array = json["data"].array {
                for item in array {
                    listArray.append(listData(json: item))
                }
            }
        }
    }
}

struct paginationData {
    var last_visible_page: Int = 0
    var has_next_page: Bool = false
    var current_page: Int = 0

    init() {
        last_visible_page = 0
        has_next_page = false
        current_page = 0
    }
    
    init(json: JSON) {
        if json != JSON.null {
            last_visible_page = json["last_visible_page"].int ?? 0
            has_next_page = json["has_next_page"].bool ?? false
            current_page = json["current_page"].int ?? 0
        }
    }
}

struct listData {
    var mal_id: Int = 0
    var url: String = ""
    var title: String = ""
    var rank: Int = 0
    var airedFrom: String = ""
    var airedTo: String = ""
    var image_url: String = ""

    init() {
        mal_id = 0
        url = ""
        title = ""
        rank = 0
        airedFrom = ""
        airedTo = ""
        image_url = ""
    }
    
    init(malId: Int, urlString: String, titleString: String, rankInt: Int, airedFromString: String, airedToString: String, imageUrlString: String) {
        mal_id = malId
        url = urlString
        title = titleString
        rank = rankInt
        airedFrom = airedFromString
        airedTo = airedToString
        image_url = imageUrlString
    }
    
    init(json: JSON) {
        if json != JSON.null {
            mal_id = json["mal_id"].int ?? 0
            url = json["url"].string ?? ""
            title = json["title"].string ?? ""
            rank = json["rank"].int ?? 0
            airedFrom = json["aired"]["from"].string ?? ""
            airedTo = json["aired"]["to"].string ?? ""
            image_url = json["images"]["jpg"]["image_url"].string ?? ""
        }
    }
}
