//
//  ButtonConfirm.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import Foundation
import UIKit
class ButtonConfirm: UIButton {
    override var isEnabled: Bool{
        didSet{
            if isEnabled {
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = .orange
                self.shadowColor = .orange.withAlphaComponent(0.4)
                self.shadowOffset = CGSize(width: 0, height: 3)
                self.shadowOpacity = 1
                self.shadowRadius = 6
            } else {
                self.setTitleColor(.gray, for: .normal)
                self.backgroundColor = .white
                self.shadowColor = .gray.withAlphaComponent(0.6)
                self.shadowOffset = CGSize(width: 0, height: 3)
                self.shadowOpacity = 1
                self.shadowRadius = 6
            }
        }
    }
}
