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
    
    func fetchCurrentUserUid() -> String {
        guard let uid = Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
    
    func fetchCurrentUser(completion: @escaping(User) -> Void) {
        fetchUser(uid: fetchCurrentUserUid(), completion: completion)
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
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        let currentUid = UserService.shared.fetchCurrentUserUid()
        DB_USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 0]) { error, ref in
            DB_USER_FOLLOWERS_REF.child(uid).updateChildValues([currentUid: 0], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        let currentUid = UserService.shared.fetchCurrentUserUid()
        DB_USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue { error, ref in
            DB_USER_FOLLOWERS_REF.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        let currentUid = UserService.shared.fetchCurrentUserUid()
        DB_USER_FOLLOWING_REF.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
