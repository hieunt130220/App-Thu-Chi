//
//  UIView+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//
import UIKit
extension UIView{
    
    /// The radius of the view's rounded corners
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// The width of the border applied to the view
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// The color of the border applied to the views
    @IBInspectable public var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable public var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    /// The offet of the shadow in the form (x, y)
    @IBInspectable public var shadowOffset: CGSize{
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// The blur of the shadown
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// The opacity of the shadow applied to the view
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}
extension UIStackView {
    @IBInspectable public var paddingTop: CGFloat {
        get {
            return layoutMargins.top
        }
        set {
            layoutMargins.top = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }
    @IBInspectable public var paddingBottom: CGFloat {
        get {
            return layoutMargins.bottom
        }
        set {
            layoutMargins.bottom = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }
    @IBInspectable public var paddingLeft: CGFloat {
        get {
            return layoutMargins.left
        }
        set {
            layoutMargins.left = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }
    @IBInspectable public var paddingRight: CGFloat {
        get {
            return layoutMargins.right
        }
        set {
            layoutMargins.right = newValue
            isLayoutMarginsRelativeArrangement = true
        }
    }
}
