//
//  LoginViewController.swift
//  TestApp
//
//  Created by Sudeepa Pal on 15/04/24.
//

import UIKit

class LoginViewController: UIViewController {

    private let logoImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(named: "logo") // Replace "logo" with your image name
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()
       
       private let usernameTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Username"
           textField.borderStyle = .roundedRect
           textField.autocapitalizationType = .none
           return textField
       }()
       
       private let passwordTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Password"
           textField.borderStyle = .roundedRect
           textField.isSecureTextEntry = true
           return textField
       }()
       
       private let loginButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Login", for: .normal)
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           button.backgroundColor = .systemBlue
           button.setTitleColor(.white, for: .normal)
           button.layer.cornerRadius = 5
           button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
           return button
       }()
    
    private let errorLabel: UILabel = {
           let label = UILabel()
           label.textColor = .red
           label.textAlignment = .center
           label.numberOfLines = 0
           return label
       }()
       
       // MARK: - Lifecycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           setupSubviews()
           
           // Add tap gesture recognizer to dismiss keyboard when tapped outside of text fields
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
           
           
       }
       
       // MARK: - Private Methods
       
       private func setupSubviews() {
           view.addSubview(logoImageView)
           view.addSubview(usernameTextField)
           view.addSubview(passwordTextField)
           view.addSubview(loginButton)
           view.addSubview(errorLabel)
           
           logoImageView.translatesAutoresizingMaskIntoConstraints = false
           usernameTextField.translatesAutoresizingMaskIntoConstraints = false
           passwordTextField.translatesAutoresizingMaskIntoConstraints = false
           loginButton.translatesAutoresizingMaskIntoConstraints = false
           errorLabel.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
               logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               logoImageView.widthAnchor.constraint(equalToConstant: 150),
               logoImageView.heightAnchor.constraint(equalToConstant: 150),
               
               usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
               usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
               usernameTextField.heightAnchor.constraint(equalToConstant: 40),
               
               passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
               passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
               passwordTextField.heightAnchor.constraint(equalToConstant: 40),
               
               loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
               loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
               loginButton.heightAnchor.constraint(equalToConstant: 50),
               
               
               errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
               errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
           ])
       }
    
    
    @objc private func dismissKeyboard() {
           view.endEditing(true)
       }
       
    @objc private func loginButtonTapped() {
           guard let email = usernameTextField.text, !email.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
               showError(message: "Please enter both email and password.")
               return
           }
           
           let parameters = ["email": email, "password": password]
           guard let url = URL(string: "https://test.webyaparsolutions.com/auth/user/login") else {
               showError(message: "Invalid URL.")
               return
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
           } catch {
               showError(message: "Failed to serialize parameters.")
               return
           }
           
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   self.showError(message: "Failed to connect to the server. Please check your internet connection and try again.")
                   return
               }
               
               do {
                   if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       if let token = responseJSON["token"] as? String {
                           // Login successful, handle token
                           print("Token: \(token)")
                           
                           let formVC = FormViewController()
                            //  formVC.token = token // Pass the token to FormViewController
                                               
                           DispatchQueue.main.async {
                            // Move to FormViewController
                            self.navigationController?.pushViewController(formVC, animated: true)
                            }
                       } else {
                           if let errorMessage = responseJSON["message"] as? String {
                               self.showError(message: errorMessage)
                           } else {
                               self.showError(message: "Unknown error occurred.")
                           }
                       }
                   } else {
                       self.showError(message: "Invalid response from the server.")
                   }
               } catch {
                   self.showError(message: "Failed to parse response.")
               }
           }
           
           task.resume()
       }
       
       private func showError(message: String) {
           DispatchQueue.main.async {
               self.errorLabel.text = message
           }
       }
}
