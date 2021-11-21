//
//  ItemModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import Foundation
import RealmSwift

class ItemModel: Object {
    @objc dynamic var type: Int = ItemType.spend.rawValue
    @objc dynamic var date: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var amount: Int = 0
    convenience init(type: ItemType, date: String, note: String, category: String, amount: Int) {
        self.init()
        self.type = type.rawValue
        self.date = date
        self.note = note
        self.category = category
        self.amount = amount
    }
}
@objc enum ItemType: Int {
    case spend
    case income
    
    var description: String {
        switch self {
        case .income:
            return "Tiền thu"
        case .spend:
            return "Tiền chi"
        }
    }
    
}