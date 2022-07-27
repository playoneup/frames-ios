//
//  UIViewExtension.swift
//  Frames
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

extension UIView {

  static var keyboardDismissTapGesture: UITapGestureRecognizer {
    let gesture = UITapGestureRecognizer(target: UIView.self, action: #selector(hideKeyboard(gestureRecognizer:)))
    gesture.cancelsTouchesInView = false
    return gesture
  }

  @objc private static func hideKeyboard(gestureRecognizer: UITapGestureRecognizer) {
    let view = gestureRecognizer.view
    let location = gestureRecognizer.location(in: view)
    let subview = view?.hitTest(location, with: nil)
    guard !(subview is SecureDisplayView) else { return }
    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
  }

}
