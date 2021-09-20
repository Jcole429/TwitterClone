//
//  ProfileFilterOptions.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/20/21.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}
