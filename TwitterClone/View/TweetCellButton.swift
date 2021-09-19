//
//  TweetCellButton.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import UIKit

class TweetCellButton: UIButton {
    
    init(imageName: String) {
        super.init(frame: .zero)
        setImage(UIImage(named: imageName), for: .normal)
        tintColor = .darkGray
        setDimensions(width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
