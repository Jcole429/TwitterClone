//
//  TweetController.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/21/21.
//

import UIKit

private let cellIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var tweet: Tweet {
        didSet {
            collectionView.reloadData()
        }
    }
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
        updateTweet()
    }
    
    // MARK: - API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    // MARK: - Helpers
    
    func updateTweet() {
        TweetService.shared.fetchTweet(tweetID: tweet.tweetID) { tweet in
            self.tweet = tweet
        }
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheetHelper(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

// MARK: - UICollectionViewDataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                
        let captionUsableWidth = view.frame.width - TweetHeader.captionUnusableWidth
        
        let captionHeight = Utilities().calculateSizeOfLabel(forWidth: captionUsableWidth, withFontSize: TweetHeader.captionFontSize, withText: tweet.caption).height
        
        let headerCellHeight = captionHeight + TweetHeader.captionUnusableHeight
        
        return CGSize(width: view.frame.width, height: headerCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let captionUsableWidth = view.frame.width - TweetCell.captionUnusableWidth
        
        let captionHeight = Utilities().calculateSizeOfLabel(forWidth: captionUsableWidth, withFontSize: TweetCell.captionFontSize, withText: tweet.caption).height
        
        let tweetCellHeight = captionHeight + TweetCell.captionUnusableHeight
        
        return CGSize(width: view.frame.width, height: tweetCellHeight)
    }
}

// MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        showActionSheetHelper(forUser: tweet.user)
    }
}

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(user: user) { error, ref in
                print("DEBUG: Followed \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("DEBUG: Unfollowed \(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
            
        case .delete:
            print("DEBUG: Delete tweet")
        }
    }
}
