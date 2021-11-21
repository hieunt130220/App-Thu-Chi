//
//  CategoryModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import Foundation
struct CategoryModel {
    let icon: String
    let title: String
    
    static func dummyData(type: ItemType) -> [CategoryModel] {
        switch type {
        case .spend:
            return [CategoryModel(icon: "", title: "Ăn uống"),
                    CategoryModel(icon: "", title: "Chi tiêu hàng ngày"),
                    CategoryModel(icon: "", title: "Quần áo"),
                    CategoryModel(icon: "", title: "Mỹ phẩm"),
                    CategoryModel(icon: "", title: "Phí giao lưu"),
                    CategoryModel(icon: "", title: "Y tế"),
                    CategoryModel(icon: "", title: "Giáo dục"),
                    CategoryModel(icon: "", title: "Điện nước"),
                    CategoryModel(icon: "", title: "Đi lại"),
                    CategoryModel(icon: "", title: "Phí liên lạc")]
        case .income:
            return [CategoryModel(icon: "", title: "Tiền lương"),
                    CategoryModel(icon: "", title: "Tiền phụ cấp"),
                    CategoryModel(icon: "", title: "Thu nhập phụ"),
                    CategoryModel(icon: "", title: "Đầu tư"),
                    CategoryModel(icon: "", title: "Thu nhập tạm thời"),
                    CategoryModel(icon: "", title: "Tiền thưởng")]
        }
    }
}
