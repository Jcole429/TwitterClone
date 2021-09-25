//
//  NotificationService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/24/21.
//

import Foundation

struct NotificationService {
    
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let uid = UserService.shared.fetchCurrentUserUid() else {return}
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        switch type {
        
        case .follow:
            print("DEBUG: Create follow notification")
            guard let user = user else {return}
            DB_NOTIFICATIONS_REF.child(user.uid).childByAutoId().updateChildValues(values)
            
        case .like, .reply:
            print("DEBUG: Create like/reply notification")
            guard let tweet = tweet else {return}
            values["tweetID"] = tweet.tweetID
            DB_NOTIFICATIONS_REF.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        
        case .retweet:
            print("DEBUG: Create retweet notification")
        
        case .mention:
            print("DEBUG: Create mention notification")
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let currentUid = UserService.shared.fetchCurrentUserUid() else {return}
        
        DB_NOTIFICATIONS_REF.child(currentUid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let notificationUid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: notificationUid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
