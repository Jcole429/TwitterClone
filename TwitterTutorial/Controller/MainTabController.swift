//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Justin Cole on 9/15/21.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    // MARK: - Helpers
    
    func configureViewControllers() {
        let feed = FeedController()
        let explore = ExploreController()
        let notifications = NotificationsController()
        let conversations = ConversationsController()
        
        viewControllers = [feed, explore, notifications, conversations]
    }
}
