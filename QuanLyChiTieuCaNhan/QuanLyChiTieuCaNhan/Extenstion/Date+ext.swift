//
//  Date+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import Foundation
extension Date{
    var year:Int{
        get{
            let calendar = Calendar.init(identifier: .gregorian)
            let components: DateComponents? = calendar.dateComponents([.year], from: self)
            return components?.year ?? 0
        }
    }
    var month:Int{
        get{
            let calendar = Calendar(identifier: .gregorian)
            let components: DateComponents? = calendar.dateComponents([.month], from: self)
            return components?.month ?? 0
        }
    }
    
    var day:Int{
        get{
            let calendar = Calendar.init(identifier: .gregorian)
            let components: DateComponents? = calendar.dateComponents([.day], from: self)
            return components?.day ?? 0
        }
    }
    
    static func dateFromComponents(year:Int, month:Int,day:Int)->Date?{
        let calendar = Calendar.init(identifier: .gregorian)
        var components: DateComponents? = calendar.dateComponents([.year, .month, .day], from: Date())
        components?.day = day
        components?.month = month
        components?.year = year
        
        if let components = components{
            let date = calendar.date(from: components)
            return date
        }
        return nil
    }
    
    static func dateFromString(dateString:String,format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateString)
    }
    
    func stringWith(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        return localDate
    }
}
