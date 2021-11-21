//
//  CategoryModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import Foundation
import RealmSwift
class CategoryModel: Object {
    @objc dynamic var type: Int = 0
    @objc dynamic var title: String = ""
    convenience init(type: ItemType, title: String) {
        self.init()
        self.type = type.rawValue
        self.title = title
    }
}
