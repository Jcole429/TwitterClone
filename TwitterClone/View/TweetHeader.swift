//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/21/21.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK: - UI Constants
    
    private static var profileImageSideLength: CGFloat = 48
    private static var userInfoStackSpacing: CGFloat = 12
    private static var userInfoStackPaddingTop: CGFloat = 16
    private static var userInfoStackPaddingLeft: CGFloat = 16
    private static var captionLabelPaddingTop: CGFloat = 12
    private static var captionLabelPaddingLeft: CGFloat = 16
    private static var captionLabelPaddingRight: CGFloat = 16
    private static var dateLabelPaddingLeft: CGFloat = 16
    private static var dateLabelPaddingTop: CGFloat = 20
    private static var statsViewPaddingTop: CGFloat = 12
    private static var statsViewHeight: CGFloat = 40
    private static var actionStackPaddingTop: CGFloat = 8
    private static var actionStackButtonSideLength: CGFloat = 20
    private static var labelStackSpacing: CGFloat = -6
    private static var fullnameLabelFontSize: CGFloat = 14
    private static var usernameLabelFontSize: CGFloat = 14
    private static var fullnameLabelHeight: CGFloat = Utilities().calculateSizeOfOneLineLabel(withFontSize: fullnameLabelFontSize).height
    private static var usernameLabelHeight: CGFloat = Utilities().calculateSizeOfOneLineLabel(withFontSize: usernameLabelFontSize).height
    
    static var captionFontSize: CGFloat = 20
    
    static var captionUnusableWidth: CGFloat = captionLabelPaddingLeft + captionLabelPaddingRight
    
    static var captionUnusableHeight: CGFloat = profileImageSideLength + userInfoStackPaddingTop + captionLabelPaddingTop + dateLabelPaddingTop + statsViewPaddingTop + statsViewHeight + actionStackPaddingTop + actionStackButtonSideLength
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: TweetHeader.profileImageSideLength, height: TweetHeader.profileImageSideLength)
        iv.makeCircle(sideLength: TweetHeader.profileImageSideLength)
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: TweetHeader.fullnameLabelFontSize)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: TweetHeader.usernameLabelFontSize)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TweetHeader.captionFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = actionStackButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = actionStackButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = actionStackButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = actionStackButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = TweetHeader.labelStackSpacing
        
        let userInfoStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        userInfoStack.spacing = TweetHeader.userInfoStackSpacing
        userInfoStack.axis = .horizontal
        
        addSubview(userInfoStack)
        userInfoStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: TweetHeader.userInfoStackPaddingTop, paddingLeft: TweetHeader.userInfoStackPaddingLeft)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: userInfoStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: TweetHeader.captionLabelPaddingTop, paddingLeft: TweetHeader.captionLabelPaddingLeft, paddingRight: TweetHeader.captionLabelPaddingRight)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: TweetHeader.dateLabelPaddingTop, paddingLeft: TweetHeader.dateLabelPaddingLeft)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: userInfoStack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: TweetHeader.statsViewPaddingTop, height: TweetHeader.statsViewHeight)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        actionStack.axis = .horizontal
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, bottom: bottomAnchor, paddingTop: TweetHeader.actionStackPaddingTop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let tweet = tweet else {return}
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        dateLabel.text = viewModel.headerTimestamp
        likesLabel.attributedText = viewModel.likesAttributedString
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
    }
    
    func actionStackButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: TweetHeader.actionStackButtonSideLength, height: TweetHeader.actionStackButtonSideLength)
        return button
    }
}
