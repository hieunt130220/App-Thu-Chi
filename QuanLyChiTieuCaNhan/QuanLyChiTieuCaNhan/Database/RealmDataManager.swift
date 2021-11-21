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
    func addObject(object: Object) ->Object{
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
    func deleteAll(except types: Object.Type...) {
        try? realm.write {
            realm.configuration.objectTypes?.filter{ type in types.contains{ $0 == type } == false}.forEach{ objectType in
                if let type = objectType as? Object.Type {
                    realm.delete(realm.objects(type))
                }
            }
        }
    }
}
extension RealmDataManager {
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
        let categories = items.map{$0.category}.uniqued()
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
