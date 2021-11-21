//
//  BaseTextView.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 20/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
class BaseTextView: UITextView {

    @IBInspectable var maxLength:Int = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame,textContainer: textContainer)
        self.commonInit()
    }
    
    func commonInit() {
        if self.delegate == nil{
            self.delegate = self
        }
    }
    
    override var text:String?{
        didSet{
            self.setTextWith(text: text, font: self.font!)
        }
    }
}
extension BaseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text.trimmingCharacters(in: .newlines)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard  textView.markedTextRange == nil ||  (textView.markedTextRange != nil && range.length > 0) else{
            return true
        }
        
        if let char = text.cString(using: String.Encoding.utf8) {
               let isBackSpace = strcmp(char, "\\b")
               if (isBackSpace == -92) {
                   print("Backspace was pressed")
                return true
               }
           }
       
        guard let currentText = textView.text,
              let rangeOfTextToReplace = Range(range, in: currentText) else {
            return false
        }

        
        let substringToReplace = currentText[rangeOfTextToReplace]
        let count = currentText.count - substringToReplace.count + text.count
        
        var updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: text)
        
        if updatedText.count > self.maxLength{
            updatedText = String(updatedText[0..<maxLength])
            textView.text = updatedText
        }
        
        return self.maxLength == 0 || count <=  self.maxLength
    }
}


extension UITextView{
    func setTextWith(text: String?, font: UIFont, lineHeight: CGFloat? = 0, lineSpacing: CGFloat? = 0, characterSpacing: CGFloat? = 0, breakMode: NSLineBreakMode? = .byCharWrapping, alignment: NSTextAlignment? = .left) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeight,lineHeight > 0 {
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
        }
        paragraphStyle.lineSpacing = lineSpacing ?? 0
        paragraphStyle.lineBreakMode = breakMode ?? .byCharWrapping
        paragraphStyle.alignment = alignment ?? .left
        attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)
        if let characterSpacing = characterSpacing{
            if #available(iOS 14.0, *) {
                attributes.updateValue(characterSpacing/50, forKey: NSAttributedString.Key.tracking)
            } else {
                // Fallback on earlier versions
                attributes.updateValue(characterSpacing/50, forKey: NSAttributedString.Key.kern)
            }
        }
        attributes.updateValue( font, forKey: NSAttributedString.Key.font)
        self.attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

