//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/25/21.
//

import Foundation
import UIKit

struct NotificationViewModel {
    
    // MARK: - Properties
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "0s"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow:
            return " started following you."
        case .like:
            return " liked your tweet."
        case .reply:
            return " replied to your tweet."
        case .retweet:
            return " retweeted your tweet."
        case .mention:
            return "mentioned you in a tweet."
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else {return nil}
        let attributedText = NSMutableAttributedString(string: user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var hideFollowButton: Bool {
        return notification.type != .follow
    }
    
    var followButtonTitle: String {
        guard let isFollowed = user.isFollowed else {return ""}
        
        return isFollowed ? "Unfollow" : "Follow"
    }
    
    // MARK: Lifecycle
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
