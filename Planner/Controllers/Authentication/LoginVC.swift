//
//  LoginVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/16.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

// MARK: - Protocols

protocol LoginDelegate {
    func startListeningChallengeDatas()
}

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    var delegate: LoginDelegate?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.mainBackground
        imageView.image = UIImage(named: "conquer")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAutenticationButton(title: "Log In", color: Color.mainBlue)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.gray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.backgroundColor = Color.mainBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.fill.badge.plus"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegisterBtn))
        navigationItem.rightBarButtonItem?.tintColor = Color.mainYellow
        
        loginButton.addTarget(self,
                              action: #selector(didTapLoginBtn),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 50,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width-60,
                                     height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width-60,
                                   height: 52)
    }
    
    // MARK: - Actions
    
    @objc private func didTapLoginBtn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty else {
                  alertuserLoginError(message: "請填妥所有欄位")
                  return
              }
        
        guard password.count >= 6 else {
            alertuserLoginError(message: "密碼需大於6個字")
            return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let auth = authResult, error == nil else {
                self?.alertuserLoginError(message: "請確認輸入的帳密")
                print("Failed to log in user with email: \(email)")
                return
            }
            
            let user = auth.user
            
            DatabaseManager.shared.setUserDefaults(with: email)
            self?.delegate?.startListeningChallengeDatas()
            
            print("Logged In User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc func didTapRegisterBtn() {
        let vc = RegisterVC()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    
    private func alertuserLoginError(message: String) {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確認", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

//MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            emailField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.becomeFirstResponder()
        }
        
        return true
    }
    
}
