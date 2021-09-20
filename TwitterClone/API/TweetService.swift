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
        
        let ref = DB_TWEETS_REF.childByAutoId()
        
        ref.updateChildValues(values) { error, ref in
            guard let tweetID = ref.key else {return}
            DB_USER_TWEETS_REF.child(uid).updateChildValues([tweetID: 0], withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_TWEETS_REF.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user,tweetID: snapshot.key, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
