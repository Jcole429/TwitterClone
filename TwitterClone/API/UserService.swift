//
//  UserService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/17/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchCurrentUser(completion: @escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
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
}
