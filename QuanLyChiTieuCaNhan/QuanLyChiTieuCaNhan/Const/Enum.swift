//
//  Enum.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 18/11/2021.
//

import Foundation

enum Period: Int {
    case month
    case year
}
enum ItemType: Int {
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
