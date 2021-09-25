//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/25/21.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: - UI Constants
    static private let profileImageSideLength: CGFloat = 40
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: NotificationCell.profileImageSideLength, height: NotificationCell.profileImageSideLength)
        iv.makeCircle(sideLength: NotificationCell.profileImageSideLength)
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor:  leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
    
    // MARK: -  Helpers
    
    func configure() {
        guard let notification = notification else {return}
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
    }
}
