//
//  TweetService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        DB_TWEETS_REF.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
