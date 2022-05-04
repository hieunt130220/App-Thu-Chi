//
//  AuthButton.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import UIKit
@IBDesignable
class AuthButton: UIButton {
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
                self.backgroundColor = .gray.withAlphaComponent(0.2)
                self.shadowColor = .gray.withAlphaComponent(0.6)
                self.shadowOffset = CGSize(width: 0, height: 3)
                self.shadowOpacity = 1
                self.shadowRadius = 6
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

