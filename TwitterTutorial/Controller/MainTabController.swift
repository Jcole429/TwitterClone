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
        
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        notifications.tabBarItem.image = UIImage(named: "like_unselected")
        conversations.tabBarItem.image = UIImage(named: "mail")
        
        viewControllers = [feed, explore, notifications, conversations]
    }
}
