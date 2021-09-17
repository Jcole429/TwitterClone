//
//  AuthService.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/16/21.
//

import Firebase

struct AuthCredentials {
    let email: String
    let username: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        // Get image data and create filename
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES_REF.child(filename)
        
        // Upload the image to firebase
        storageRef.putData(imageData, metadata: nil) { meta, error in
            if let error = error {
                print("DEBUG: Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: Error downloading image url: \(error.localizedDescription)")
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error = error {
                        print("DEBUG: Error creating user: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let user_values = ["email": credentials.email, "username": credentials.username, "fullname": credentials.fullname, "profileImageUrl": profileImageUrl]
                    
                    DB_USERS_REF.child(uid).updateChildValues(user_values, withCompletionBlock: completion)
                }
            }
        }
    }
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
