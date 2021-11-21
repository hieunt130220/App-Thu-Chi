//
//  NSObject+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/3 Reiwa.
//

import Foundation
extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

extension Int {
    func formatCurrency(symbol: String = "đ") -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = symbol
        formatter.currencyGroupingSeparator = ","
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,##0 ¤"
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
