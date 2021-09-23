//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - UI Constants
    
    private static var profileImageSideLength: CGFloat = 48
    private static var profileImagePaddingTop: CGFloat = 8
    private static var profileImagePaddingLeft: CGFloat = 8
    private static var captionStackPaddingTop: CGFloat = 8
    private static var captionStackPaddingLeft: CGFloat = 12
    private static var captionStackPaddingRight: CGFloat = 12
    
    private static var infoLabelHeight: CGFloat = Utilities().calculateSizeOfOneLineLabel(withFontSize: 14).height
    private static var captionStackSpacing: CGFloat = 4
    private static var actionStackPaddingTop: CGFloat = 12
    private static var actionStackPaddingBottom: CGFloat = 8
    private static var dividerHeight: CGFloat = 1
    private static var dividerPaddingTop: CGFloat = 8
    
    static var captionFontSize: CGFloat = 14
    
    static var captionUnusableWidth: CGFloat = profileImageSideLength + profileImagePaddingLeft + captionStackPaddingLeft + captionStackPaddingRight
    
    static var captionUnusableHeight: CGFloat = captionStackPaddingTop + infoLabelHeight + captionStackSpacing + actionStackPaddingTop + TweetCellButton.buttonSideLength + actionStackPaddingBottom + dividerPaddingTop + dividerHeight
    
    // MARK: - Properties
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: TweetCell.profileImageSideLength, height: TweetCell.profileImageSideLength)
        iv.makeCircle(sideLength: TweetCell.profileImageSideLength)
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: captionFontSize)
        label.numberOfLines = 0
        label.text = "Test tweet"
        return label
    }()
    
    private lazy var commentButton: TweetCellButton = {
        let button = TweetCellButton(imageName: "comment")
        button.addTarget(self, action: #selector(handleReplyTapped), for: .touchUpInside)
        return button
    }()
    private lazy var retweetButton: TweetCellButton = {
        let button = TweetCellButton(imageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    private lazy var likeButton: TweetCellButton = {
        let button = TweetCellButton(imageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton: TweetCellButton = {
        let button = TweetCellButton(imageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: TweetCell.profileImagePaddingTop, paddingLeft: TweetCell.profileImagePaddingLeft)
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = TweetCell.captionStackSpacing
        
        addSubview(captionStack)
        captionStack.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: TweetCell.captionStackPaddingTop, paddingLeft: TweetCell.captionStackPaddingLeft, paddingRight: TweetCell.captionStackPaddingRight)
        
        infoLabel.font = UIFont.systemFont(ofSize: TweetCell.captionFontSize)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: captionStack.bottomAnchor, paddingTop: TweetCell.actionStackPaddingTop, paddingBottom: TweetCell.actionStackPaddingBottom)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(top: actionStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: TweetCell.dividerPaddingTop, height: TweetCell.dividerHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleReplyTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        print("DEBUG: Handling")
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG: Handling")
    }
    
    @objc func handleShareTapped() {
        print("DEBUG: Handling")
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        infoLabel.attributedText = viewModel.userInfoText
        captionLabel.text = tweet.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
    }
}
