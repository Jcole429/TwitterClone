//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/20/21.
//

import UIKit

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else if user.isFollowed {
            return "Following"
        } else {
            return "Follow"
        }
    }
    
    var usernameString: String {
        return "@\(self.user.username)"
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
