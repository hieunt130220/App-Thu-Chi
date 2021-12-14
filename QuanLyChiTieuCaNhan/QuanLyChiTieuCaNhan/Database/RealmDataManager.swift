//
//  RealmDataManager.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import Foundation
import RealmSwift
import RxSwift
class RealmDataManager: NSObject {
    
    var realm: Realm!
    static let shared = RealmDataManager()
    
    override init() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                migration.enumerateObjects(ofType: ItemModel.className()) {oldObject,newObject in }
            }
        }
        realm = try! Realm(configuration: config)
        
        print("RealmURL:\(Realm.Configuration.defaultConfiguration.fileURL )")
        
    }
    
    //MARK: common functions
    @discardableResult
    func addObject(object: Object) -> Object{
        try! realm.write {
            realm.add(object)
        }
        return object
    }
    func delete(object: Object) -> Bool {
        try! realm.write {
            realm.delete(object)
            return true
        }
    }
    func createCategory() {
        let arrayCategory = [CategoryModel(type: .spend, title: "Ăn uống"),
                             CategoryModel(type: .spend, title: "Chi tiêu hàng ngày"),
                             CategoryModel(type: .spend, title: "Quần áo"),
                             CategoryModel(type: .spend, title: "Mỹ phẩm"),
                             CategoryModel(type: .spend, title: "Phí giao lưu"),
                             CategoryModel(type: .spend, title: "Y tế"),
                             CategoryModel(type: .spend, title: "Giáo dục"),
                             CategoryModel(type: .spend, title: "Điện nước"),
                             CategoryModel(type: .spend, title: "Đi lại"),
                             CategoryModel(type: .spend, title: "Phí liên lạc"),
                             CategoryModel(type: .income, title: "Tiền lương"),
                             CategoryModel(type: .income, title: "Tiền phụ cấp"),
                             CategoryModel(type: .income, title: "Thu nhập phụ"),
                             CategoryModel(type: .income, title: "Đầu tư"),
                             CategoryModel(type: .income, title: "Thu nhập tạm thời"),
                             CategoryModel(type: .income, title: "Tiền thưởng")]
        for item in arrayCategory {
            self.addObject(object: item)
        }
    }
}
extension RealmDataManager {
    func getCategory(type: ItemType) -> [CategoryModel] {
        return realm.objects(CategoryModel.self)
            .filter{$0.type == type.rawValue}
            .compactMap{$0}
    }
    func getItemsByDay(date: Date) -> [ItemModel] {
        let dateString = date.stringWith(format: "dd/MM/yyyy")
        return realm.objects(ItemModel.self)
            .filter{$0.date == dateString}
            .compactMap{$0}
            .sorted { $0.type > $1.type }
    }
    func getTotalByPeriod(time:Date, period: Period) -> (Int,Int) {
        var timeString = ""
        switch period {
        case .month:
            timeString =  time.stringWith(format: "MM/yyyy")
        case .year:
            timeString = time.stringWith(format: "yyyy")
        }
        let income:Int = realm.objects(ItemModel.self)
            .filter("date CONTAINS[c] %@ AND type = 1", timeString)
            .sum(ofProperty: "amount")
        let spend:Int = realm.objects(ItemModel.self)
            .filter("date CONTAINS[c] %@ AND type = 0", timeString)
            .sum(ofProperty: "amount")
        return (spend, income)
    }
    func getListItemByPeriod(time:Date, type: ItemType, period: Period) -> [[String:Any]] {
        var timeString = ""
        switch period {
        case .month:
            timeString =  time.stringWith(format: "MM/yyyy")
        case .year:
            timeString = time.stringWith(format: "yyyy")
        }
        let items = realm.objects(ItemModel.self)
            .filter{item in
                return item.date.contains(timeString) && item.type == type.rawValue
            }
            .compactMap{$0}
        var categories = [String]()
        for item in items {
            categories.append(item.category)
        }
        categories = categories.uniqued()
        return categories.compactMap { category -> [String:Any] in
            let total = items
                .filter{$0.category == category}
                .map {$0.amount}
                .reduce(0, +)
            switch type {
            case .spend:
                return ["\(category)":total]
            case .income:
                return ["\(category)":total]
            }
        }
    }
    func getTotalCategoryByMonth(category: String, date: Date) -> [Int] {
        let currentYear = date.year
        var totalArray = [Int]()
        var monthString = ""
        for month in 1...12 {
            
            if month < 10 {
                monthString = "0\(month)/\(currentYear)"
            } else {
                monthString = "\(month)/\(currentYear)"
            }
            
            let total:Int = realm.objects(ItemModel.self)
                .filter("date CONTAINS[c] %@ AND category = %@", monthString, category)
                .sum(ofProperty: "amount")
            totalArray.append(total)
        }
        return totalArray
    }
    func getItemByCategory(category: String, time: Date) -> [ItemModel] {
        let monthString = time.stringWith(format: "MM/yyyy")
        return realm.objects(ItemModel.self)
            .filter("category = %@ AND date CONTAINS[c] %@", category, monthString)
            .compactMap{$0}
    }
    func sum(items:[ItemModel]) -> Int {
        var sum: Int = 0
        for item in items {
            sum += item.amount
        }
        return sum
    }
}
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
