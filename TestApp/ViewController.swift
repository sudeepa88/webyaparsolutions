//
//  ViewController.swift
//  TestApp
//
//  Created by Sudeepa Pal on 14/04/24.
//

import UIKit


struct SignupResponse: Codable {
    // Define any response properties you expect from the server
    // For simplicity, assuming the server returns a success message
    let message: String
    let success: Bool
}

class ViewController: UIViewController {
    
    
    let nameTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Name"
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
    

    let emailTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Email"
           textField.borderStyle = .roundedRect
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
       }()
       
       let passwordTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Password"
           textField.borderStyle = .roundedRect
           //textField.isSecureTextEntry = true
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
       }()
       
       let signupButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Sign Up", for: .normal)
           button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
       // MARK: - View Lifecycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           setupViews()
       }
       
       // MARK: - Private Methods
       
       private func setupViews() {
           view.backgroundColor = .white
           
           view.addSubview(nameTextField)
           view.addSubview(emailTextField)
           view.addSubview(passwordTextField)
           view.addSubview(signupButton)
           
           NSLayoutConstraint.activate([
                        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
                        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
                        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
                        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
                        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
                        signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
                        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
           ])
       }
       
       // MARK: - Actions
       
    @objc private func signupButtonTapped() {
            guard let name = nameTextField.text,
                  let email = emailTextField.text,
                  let password = passwordTextField.text else {
                return
            }
            
            // Create request body
            let parameters = ["name": name,
                              "email": email,
                              "password": password]
            
            // Create URL
            guard let baseURL = URL(string: "https://test.webyaparsolutions.com"),
                  let url = URL(string: "/auth/user/signup", relativeTo: baseURL) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                // Convert parameters to JSON data
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                // Make the request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    // Check for successful response
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Server error")
                        return
                    }
                    
                    // Parse response data
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(SignupResponse.self, from: data)
                            print("Response message: \(response.message)")
                            // Handle success message here
                            if response.success {
                                print("Response message: \(response.message )")
                                        DispatchQueue.main.async {
                                                                // Navigate to LoginViewController
                                        let loginViewController = LoginViewController() // Change this to your LoginViewController class
                                        self.navigationController?.pushViewController(loginViewController, animated: true)
                                                            }
                                                        } else {
                                                            print("Error: \(response.message )")
                                                            // Handle error
                                                        }
                            
                        } catch {
                            print("Error decoding response: \(error)")
                        }
                    }
                }
                task.resume()
                
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
}

