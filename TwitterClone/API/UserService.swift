//
//  UserService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/17/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("DEBUG: Current user id \(uid)")
        
        DB_USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            print("DEBUG: username: \(user.username)")
            print("DEBUG: fullName: \(user.fullname)")
            print("DEBUG: email: \(user.email)")
            print("DEBUG: profileImageUrl: \(user.profileImageUrl)")
        }
    }
}
