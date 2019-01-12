//
//  Parser.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Parser {
    static func parse(json: JSON) -> [Post] {
        
        var postAray = [Post]()
        
        var groupsDict : [String:JSON] = [:]
        let groups = json["groups"]
        
        for i in 0..<groups.arrayValue.count {
            let currGroup = groups.arrayValue[i]
            let idGroup = currGroup["id"].stringValue as String
            groupsDict[idGroup] = currGroup
        }
        
        var profilesDict : [String:JSON] = [:]
        let profiles = json["profiles"]
        
        for i in 0..<profiles.arrayValue.count {
            let currProfiles = profiles.arrayValue[i]
            let idProfiles = currProfiles["id"].stringValue as String
            profilesDict[idProfiles] = currProfiles
        }
        
        let item = json["items"]
        
        for i in 0..<item.arrayValue.count {
            
            
            let currItem = item.arrayValue[i]
            let date : String = currItem["date"].stringValue as String
            let text : String = currItem["text"].stringValue as String
            let like : Int = Int(currItem["likes"]["count"].stringValue) ?? 0
            let viewes : Int = Int(currItem["views"]["count"].stringValue) ?? 0
            
            var sourceId : Int = 0
            if let id = Int(currItem["source_id"].stringValue as String) {
                sourceId = id
            } else if let id = Int(currItem["from_id"].stringValue as String) {
                sourceId = id
            }
            
            let sourceDict : [String:JSON] = sourceId < 0 ? groupsDict : profilesDict
            let avatarUrl : String = sourceDict[String(abs(sourceId))]!["photo_50"].stringValue as String
            var name : String = ""
            
            let sourceProfile = sourceDict[String(abs(sourceId))]!
            if sourceProfile["type"] == JSON.null {
                name = "\(sourceProfile["first_name"].stringValue) \(sourceProfile["last_name"].stringValue)"
            } else {
                name = sourceProfile["name"].stringValue
            }
            
            let attachments = currItem["attachments"]
            var photos = [Photo]()
            
            for j in 0..<attachments.arrayValue.count {
                
                let currAttachment = attachments.arrayValue[j]
                let type = currAttachment["type"].stringValue as String
                
                if (type == "photo") {
                    let photoSizes = currAttachment["photo"]["sizes"].arrayValue
                    
                    for l in 0..<photoSizes.count {
                        let typeSize = photoSizes[l]["type"]
                        
                        if (typeSize == "z" || typeSize == "y") {
                            let photo = Photo(url: URL(string: photoSizes[l]["url"].stringValue)!, width: photoSizes[l]["width"].intValue, height: photoSizes[l]["height"].intValue)
                            photos.append(photo)
                            break
                        }
                        
                    }
                    continue
                }
            }
            
            
            if (photos.count == 0 && text == ""){
                continue
            }
            
            var post = Post(name: name, time: date, avatarURLString: avatarUrl)
            
            post.text = text
            post.likes = like
            post.viewes = viewes
            post.photos.append(contentsOf: photos)
            postAray.append(post)
        }
        
        return postAray
        
    }

}
