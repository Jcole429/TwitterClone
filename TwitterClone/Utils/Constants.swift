//
//  Constants.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/16/21.
//

import Firebase

let DB_REF = Database.database().reference()
let DB_USERS_REF = DB_REF.child("users")
let DB_TWEETS_REF = DB_REF.child("tweets")
let DB_USER_TWEETS_REF = DB_REF.child("user-tweets")
let DB_USER_TWEET_REPLIES_REF = DB_REF.child("tweet-replies")
let DB_USER_FOLLOWERS_REF = DB_REF.child("user-followers")
let DB_USER_FOLLOWING_REF = DB_REF.child("user-following")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")
