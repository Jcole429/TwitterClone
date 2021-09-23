//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/23/21.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    // MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "twitter_logo_blue")
        iv.setDimensions(width: 36, height: 36)
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let optionStack = UIStackView(arrangedSubviews: [optionImageView, titleLabel])
        optionStack.axis = .horizontal
        optionStack.spacing = 12
        
        addSubview(optionStack)
        optionStack.centerY(inView: self)
        optionStack.anchor(left: leftAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        titleLabel.text = option?.description
    }
    
}
