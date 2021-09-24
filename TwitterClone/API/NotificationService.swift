//
//  NotificationService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/24/21.
//

import Foundation

struct NotificationService {
    
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet?) {
        print("DEBUG: Type is: \(type)")
        guard let uid = UserService.shared.fetchCurrentUserUid() else {return}
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        switch type {
        case .follow:
            print("DEBUG: Create follow notification")
        case .like:
            guard let tweet = tweet else {return}
            values["tweetID"] = tweet.tweetID
            DB_NOTIFICATIONS_REF.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        case .reply:
            print("DEBUG: Create reply notification")
        case .retweet:
            print("DEBUG: Create retweet notification")
        case .mention:
            print("DEBUG: Create mention notification")
        }
    }
}
