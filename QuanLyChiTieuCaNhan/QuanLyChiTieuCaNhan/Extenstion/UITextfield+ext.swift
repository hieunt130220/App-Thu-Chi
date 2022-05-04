//
//  UITextfield+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import Foundation
import UIKit
extension UITextField {
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 216))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "vi_VN")
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Xong", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
