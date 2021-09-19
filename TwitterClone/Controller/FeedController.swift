//
//  FeedController.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/15/21.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            print("DEBUG: Did set user in FeedController..")
            configureLeftBarButton()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            print("DEBUG: Tweets: \(tweets)")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width:32, height: 32)
        profileImageView.makeCircle(sideLength: 32)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        profileImageView.layer.masksToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
