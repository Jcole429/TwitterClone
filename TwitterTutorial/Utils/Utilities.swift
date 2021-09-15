//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by Justin Cole on 9/15/21.
//

import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        view.setDimensions(height: 50)
        
        let iv = UIImageView()
        view.addSubview(iv)
        iv.image = image
        iv.setDimensions(width: 24, height: 24)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let dividerView = UIView()
        view.addSubview(dividerView)
        dividerView.backgroundColor = .white
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.75)
        
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String, isSecure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.isSecureTextEntry = isSecure
        return tf
    }
}
