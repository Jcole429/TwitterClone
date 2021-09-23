//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/23/21.
//

import UIKit

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Helpers
    
    func show() {
        print("DEBUG: Show actionsheet for user \(user.username)")
    }
}
