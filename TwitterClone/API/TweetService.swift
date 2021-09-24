//
//  TweetService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = UserService.shared.fetchCurrentUserUid() else {return}
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        switch type {
        case .tweet:
            DB_TWEETS_REF.childByAutoId().updateChildValues(values) { error, ref in
                guard let tweetID = ref.key else {return}
                DB_USER_TWEETS_REF.child(uid).updateChildValues([tweetID: 0], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            DB_TWEET_REPLIES_REF.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_TWEETS_REF.observe(.childAdded) { snapshot in
            convertSnapshotToTweet(snapshot: snapshot) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        DB_USER_TWEETS_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key

            fetchTweet(tweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_TWEET_REPLIES_REF.child(tweet.tweetID).observe(.childAdded) { snapshot in
            convertSnapshotToTweet(snapshot: snapshot) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = UserService.shared.fetchCurrentUserUid() else {return}
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        DB_TWEETS_REF.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            DB_USER_LIKES_REF.child(uid).child(tweet.tweetID).removeValue { error, ref in
                DB_TWEET_LIKES_REF.child(tweet.tweetID).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            DB_USER_LIKES_REF.child(uid).updateChildValues([tweet.tweetID: 0]) { error, ref in
                DB_TWEET_LIKES_REF.child(tweet.tweetID).updateChildValues([uid: 0]) { error, reference in
                    completion(error, reference)
                    NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
                }
            }
        }
    }
    
    func checkIfUserLikedTweet(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = UserService.shared.fetchCurrentUserUid() else {return}
        
        DB_USER_LIKES_REF.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchTweet(tweetID: String, completion: @escaping(Tweet) -> Void) {
        DB_TWEETS_REF.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            convertSnapshotToTweet(snapshot: snapshot) { tweet in
                completion(tweet)
            }
        }
    }
    
    func convertSnapshotToTweet(snapshot: DataSnapshot, completion: @escaping(Tweet) -> Void) {
        guard let dictionary = snapshot.value as? [String: Any] else {return}
        guard let uid = dictionary["uid"] as? String else {return}
        let tweetID = snapshot.key
        
        UserService.shared.fetchUser(uid: uid) { user in
            var tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { didLike in
                tweet.didLike = didLike
                completion(tweet)
            }
        }
    }
}
