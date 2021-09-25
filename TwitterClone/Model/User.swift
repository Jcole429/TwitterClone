//
//  User.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/19/21.
//

import Foundation
import Firebase

struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed: Bool?
    var stats: UserRelationStats?
    
    var isCurrentUser: Bool { return UserService.shared.fetchCurrentUserUid() == self.uid }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = URL(string: dictionary["profileImageUrl"] as! String)
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
