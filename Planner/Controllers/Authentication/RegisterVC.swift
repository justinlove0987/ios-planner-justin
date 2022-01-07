//
//  RegisterVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/16.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterVC: UIViewController {
    
    // MARK: - Properties
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let usernameField: UITextField = {
        let field = CustomAutenticationTextField(placeholder: "Username")
        return field
    }()
    
    private let emailField: UITextField = {
        let field = CustomAutenticationTextField(placeholder: "Email")
        field.keyboardType = .emailAddress
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = CustomAutenticationTextField(placeholder: "Password")
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setAutenticationButton(title: "Register", color: Color.mainDarkGreen)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = Color.mainBackground

        
        registerBtn.addTarget(self,
                                 action: #selector(didTapRegisterBtn),
                                 for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(userImageView)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerBtn)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        userImageView.addGestureRecognizer(gesture)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        userImageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        userImageView.layer.cornerRadius = userImageView.width / 2.0
        
        usernameField.frame = CGRect(x: 30,
                                      y: userImageView.bottom + 10,
                                      width: scrollView.width-60,
                                      height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: usernameField.bottom + 10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width-60,
                                     height: 52)
        registerBtn.frame = CGRect(x: 30,
                                      y: passwordField.bottom + 10,
                                      width: scrollView.width-60,
                                      height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapRegisterBtn() {
        
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            alertUserRegisterError(message: "請填入所有欄位")
            return
        }
        
        guard password.count >= 6 else {
            alertUserRegisterError(message: "密碼長度須大於6")
            return
        }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                // user already exists
                strongSelf.alertUserRegisterError(message: "此email已被註冊")
                return
            }
            
            print(exists)
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    strongSelf.alertUserRegisterError(message: "請確認網路連線")
                    print("Error creating user")
                    return
                }
                
                let chatUser = ChatAppUser(username: username,
                                           emailAddress: email)
                
                DatabaseManager.shared.setUserDefaults(with: email)
                
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        // upload image
                        guard let image = strongSelf.userImageView.image, let data = image.pngData() else {
                            return
                        }
                        let fileName = chatUser.profilePictrueFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage manageer error: \(error)")
                            }
                        }
                    }
                }
                
//                self?.delegate?.loadChallengeData()
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    // MARK: - Helpers
    
    func alertUserRegisterError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確認", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.becomeFirstResponder()
        } else if textField == usernameField {
            usernameField.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presnetCamera()})) // self become optional because of the weak modifier
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentPhotoPicker()}))
        
        present(actionSheet, animated: true)
        
        
    }
    
    func presnetCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  else { return }// editedImage -> the square one
        
         self.userImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
