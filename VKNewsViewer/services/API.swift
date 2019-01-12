//
//  API.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import Foundation
import SwiftyJSON

final class API {
    
    public var token: String? {
        didSet {
            UserDefaults.standard.set(token, forKey: "ACCESS_TOKEN")
        }
    }
    public var expires: Date? {
        didSet {
            UserDefaults.standard.set(expires, forKey: "EXPIRES_TOKEN")
        }
    }
    
    public let authURL = URL(string: "https://oauth.vk.com/authorize?client_id=6714207&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=wall%2Cfriends&response_type=token&v=5.78")!
    
    private let secret = "KJ4o2yLYIXcwz6IqwJa0"
    
    static let shared = API()
    
    private init() {
        
    }
    private var lastPost: String = ""
    public func getNews(backPost : @escaping ([Post]) -> (), isGetNext: Bool = false) {
        
        var params = ["filters": "post" , "fields":"members_count", "count": "25"]
        
        if isGetNext {
            params["start_from"] = lastPost
        }
        self.callbackApi(method: "newsfeed.get", params: params) {
            
            backPost(Parser.parse(json: $0))
            
            self.lastPost = $0["next_from"].stringValue
            
        }
    }
    
    public func searchNews(query: String, backPost : @escaping ([Post]) -> (), isGetNext: Bool = false) {
        var params = ["filters": "post", "q": "\(query)" , "extended":"1", "count": "25"]
        
        if isGetNext {
            params["start_from"] = lastPost
        }
        
        self.callbackApi(method: "newsfeed.search", params: params) {
            
            backPost(Parser.parse(json: $0))
            
            self.lastPost = $0["next_from"].stringValue
            
        }
        
    }
    
    private func callbackApi(method : String, params : [String:String], callbackFun : @escaping (JSON) -> ())  {
        
        guard token != nil else {
            return
        }
        
        var params = params
        
        params["access_token"] = token
        params["client_secret"] = secret
        params["v"] = "5.78"
        
        
        let paramsString = (params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        
        let urlStr = "https://api.vk.com/method/\(method)?\(paramsString)"
        let url = URL(string: urlStr)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let json = JSON(data!)
            callbackFun(json["response"])
        }
        
        task.resume()
        
    }
    
    
}
