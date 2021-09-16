//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Justin Cole on 9/15/21.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 128, height: 128)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.layer.cornerRadius = 128/2
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: usernameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password", isSecure: true)
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Username")
        return tf
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.setDimensions(height: 50)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    // MARK: - Selectors
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let values = ["email": email, "username": username, "fullname": fullname]
            
            let userDatabaseRef = USERS_REF.child(uid)
            
            userDatabaseRef.updateChildValues(values) { error, ref in
                print("DEBUG: Successfully updated user information")
            }
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView, registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard var profileImage = info[.editedImage] as? UIImage else {return}
        
        profileImage = profileImage.withRenderingMode(.alwaysOriginal)
        
        self.plusPhotoButton.setImage(profileImage, for: .normal)
        self.plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        self.plusPhotoButton.layer.borderWidth = 3
        
        self.dismiss(animated: true, completion: nil)
    }
}
