//
//  KeyboardFollower.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import Foundation
import UIKit

class KeyboardFollower: NSObject {
    public enum AppearType {
        case show
        case hide

        public var isShow: Bool {
            return self == .show
        }

        public var isHide: Bool {
            return self == .hide
        }
    }

    private var animationsBlock: ((CGRect, Double, AppearType) -> Void)?
    private var completionBlock: ((Bool) -> Void)?
    
    public func follow(withAnimations animationsBlock: ((CGRect, Double, AppearType) -> Void)?, completionBlock: ((Bool) -> Void)? = nil) {

        self.animationsBlock = animationsBlock
        self.completionBlock = completionBlock

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    public func unfollow() {
        self.animationsBlock = nil
        self.completionBlock = nil
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func executeAnimation(notification: Notification, type: AppearType) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curveRaw)!)
            self.animationsBlock?(keyboardFrame, duration, type)

        }, completion: completionBlock)

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        executeAnimation(notification: notification, type: .show)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        executeAnimation(notification: notification, type: .hide)
    }
}
