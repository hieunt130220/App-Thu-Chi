//
//  BaseTextField.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 20/11/2021.
//

import Foundation
import UIKit
class BaseTextField: UITextField {
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10))
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10))
    }
}
