//
//  Utilities.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-06.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email : String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
}

extension UITextField {
    
    func setUnderline() {
        // Border underline setup
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    func setTextFieldWithIconAndBorder(fsSymbol: String) {
        
        //Icon setup
        let image = UIImage(systemName: fsSymbol)
        let iconView = UIImageView(frame:
                      CGRect(x: 0, y: 5, width: 30, height: 30))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 50, height: 40))
        iconView.tintColor = UIColor.darkGray
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        
        // Border underline setup
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
}

extension UIStackView {
    func addColor() {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

extension UIButton {
    
    func styleButton() {
        self.layer.borderWidth = 2
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 20
        self.tintColor = UIColor.black
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

// Animations

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    // Using SpringWithDamping
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)

    }
    
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: CGFloat(0.20),initialSpringVelocity: CGFloat(6.0),options: UIView.AnimationOptions.allowUserInteraction,animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { Void in()  }
        )
    }
}
