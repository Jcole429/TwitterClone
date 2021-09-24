//
//  UserService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/17/21.
//

import Firebase

typealias DatabaseCompletion = (Error?, DatabaseReference) -> Void

struct UserService {
    static let shared = UserService()
    
    func fetchCurrentUserUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func fetchCurrentUser(completion: @escaping(User) -> Void) {
        guard let uid = fetchCurrentUserUid() else {return}
        fetchUser(uid: uid, completion: completion)
    }
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void){
        DB_USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        DB_USERS_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = UserService.shared.fetchCurrentUserUid() else {return}
        DB_USER_FOLLOWING_REF.child(currentUid).updateChildValues([user.uid: 0]) { error, ref in
            DB_USER_FOLLOWERS_REF.child(user.uid).updateChildValues([currentUid: 0]) { error, ref in
                completion(error, ref)
                if error == nil {
                    NotificationService.shared.uploadNotification(type: .follow, user: user)
                }
            }
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = UserService.shared.fetchCurrentUserUid() else {return}
        DB_USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue { error, ref in
            DB_USER_FOLLOWERS_REF.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = UserService.shared.fetchCurrentUserUid() else {return}
        DB_USER_FOLLOWING_REF.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        DB_USER_FOLLOWERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followersCount = snapshot.children.allObjects.count
            
            DB_USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                let followingCount = snapshot.children.allObjects.count
                let stats = UserRelationStats(followers: followersCount, following: followingCount)
                completion(stats)
            }
        }
    }
}
