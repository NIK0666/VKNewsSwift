//
//  Post.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import Foundation

struct Post {
    let name: String
    var time: String!
    var avatarURL: URL!
    
    var text: String?
    var photos = [Photo]()
    
    var likes: Int = 0
    var viewes: Int = 0
    
    init(name: String, time: String, avatarURLString: String) {
        self.name = name
        self.avatarURL = URL(string: avatarURLString)
        self.time = formatDate(time)

    }
    
    
    private func formatDate(_ unixTime:String) -> String{
        
        guard let unixTimeInt = Double(unixTime) else {
            return ""
        }
        let currentDate = Date()
        let date = Date(timeIntervalSince1970: unixTimeInt)

        
        let minutes = Int(floor((currentDate.timeIntervalSince1970 - unixTimeInt) / 60));
        let hours = Int(floor(Double(minutes) / 60))
        let minutesAtHour = Int(minutes) % 60
        switch (Int(hours), minutesAtHour) {
        case (0, 0):
            return "только что"
        case (0, 1...59):
            if minutesAtHour % 10 == 0 {
                return "\(minutesAtHour) минут назад"
            } else if minutesAtHour % 10 == 1 {
                return "\(minutesAtHour) минуту назад"
            } else if minutesAtHour % 10 < 5 {
                return "\(minutesAtHour) минуты назад"
            } else {
                return "\(minutesAtHour) минут назад"
            }
        case (1, _): 
            return "час назад"
        case (2...4, _):
            return "\(hours) часа назад"
        case (5...12, _):
            return "\(hours) часов назад"
        case (13...24 + Calendar.current.component(.hour, from: currentDate), _):
            let currentDay = Calendar.current.component(.day, from: currentDate)
            let dateDay = Calendar.current.component(.day, from: date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            
            if (currentDay == dateDay){
                return "сегодня в \(formatter.string(from: date))"
            } else {
                return "вчера в \(formatter.string(from: date))"
            }
        default:
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM в HH:mm"
            formatter.locale =  Locale(identifier: "ru_RU")
            return formatter.string(from: date)
        }
    }
    
}
