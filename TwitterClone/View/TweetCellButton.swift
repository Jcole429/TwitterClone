//
//  TweetCellButton.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import UIKit

class TweetCellButton: UIButton {
    
    static var buttonSideLength: CGFloat = 20
    
    init(imageName: String) {
        super.init(frame: .zero)
        setImage(UIImage(named: imageName), for: .normal)
        tintColor = .darkGray
        setDimensions(width: TweetCellButton.buttonSideLength, height: TweetCellButton.buttonSideLength)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
