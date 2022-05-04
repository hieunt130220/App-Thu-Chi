//
//  UIView+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//
import UIKit
fileprivate var activityIndicatorViewAssociativeKey = "activityIndicatorViewAssociativeKey"

public class RCLoadingView:UIActivityIndicatorView {
    
}
public extension UIView {
    var activityIndicatorView: RCLoadingView {
        get {
            if let activityIndicatorView = objc_getAssociatedObject(self,&activityIndicatorViewAssociativeKey) as? RCLoadingView {
                bringSubviewToFront(activityIndicatorView)
                return activityIndicatorView
            } else {
                let activityIndicatorView:RCLoadingView = RCLoadingView()
                activityIndicatorView.layer.cornerRadius = 5
                activityIndicatorView.backgroundColor = .init(white: 0, alpha: 0.5)
                activityIndicatorView.style = .large
                activityIndicatorView.color = .white
                activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(activityIndicatorView)
                bringSubviewToFront(activityIndicatorView)
                NSLayoutConstraint.activate([
                    activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
                    activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                    activityIndicatorView.widthAnchor.constraint(equalToConstant: 80),
                    activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor, multiplier: 1,constant: 0)
                    
                ])
                
                objc_setAssociatedObject(self, &activityIndicatorViewAssociativeKey,activityIndicatorView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue)
            bringSubviewToFront(activityIndicatorView)
            objc_setAssociatedObject(self, &activityIndicatorViewAssociativeKey,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }

}
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
