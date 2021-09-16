//
//  Constants.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/16/21.
//

import Firebase

let DB_REF = Database.database().reference()
let DB_USERS_REF = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")
