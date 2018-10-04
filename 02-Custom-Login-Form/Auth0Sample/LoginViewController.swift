// LoginViewController.swift
// Auth0Sample
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Auth0

class LoginViewController: UIViewController {
    
  
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet var actionButtons: [UIButton]!

    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
      checkToken()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionButtons.forEach { $0.roundLaterals()}
        UserDefaults.standard.set(false, forKey: "Invitado")
    }
    
    fileprivate func checkToken() {
        startAnimating()
        let loadingAlert = UIAlertController.loadingAlert()
        loadingAlert.presentInViewController(self)
        SessionManager.shared.renewAuth { error in
            DispatchQueue.main.async {
                
                    if error != nil {
                        print("Failed to retrieve credentials: \(String(describing: error))")
                        self.stopAnimating()
                    }
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            if error != nil  {
                                print("Failed to retrieve profile: \(String(describing: error))")
                            }
                            
                            if let user = UserDefaults.standard.string(forKey: "Mail"){
                                self.performSegue(withIdentifier: "ShowProfile", sender: nil)
                                return
                            }
                           
                            if SessionManager.shared.credentials != nil {
                                self.retrievedCredentials = SessionManager.shared.credentials
                                self.stopAnimating()
                                self.performSegue(withIdentifier: "ShowProfile", sender: nil)
                            }else{
                                self.stopAnimating()
                            }
                        }
                    }
                
            }
        }
    }
    func startAnimating(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopAnimating(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBAction
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        self.performFacebookAuthentication()
    }
    
    @IBAction func loginWithTwitter(_ sender: Any) {
        self.performTwitterAuthentication()
    }
    
    @IBAction func loginWhitGoogle(_ sender: Any) {
        self.performGoogleAuthentication()
    }
    @IBAction func loginInvitado(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "Invitado")
        self.performSegue(withIdentifier: "ShowProfile", sender: nil)
    }
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileViewController = segue.destination as? ProfileViewController else {
            return
        }
        
    }
    
    // MARK: - Private
    
    fileprivate var retrievedCredentials: Credentials?
    
    fileprivate var loading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.loading {
                    self.spinner.startAnimating()
                    self.actionButtons.forEach { $0.isEnabled = false }
                } else {
                    self.spinner.stopAnimating()
                    self.actionButtons.forEach { $0.isEnabled = true }
                }
            }
        }
    }
    
    fileprivate func performFacebookAuthentication() {
        self.view.endEditing(true)
        self.loading = true
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .audience("https://" + clientInfo.domain + "/userinfo")
            .connection("facebook")
            .scope("openid profile email")
            .start { result in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    switch result {
                    case .success(let credentials):
                        
                        self.loginWithCredentials(credentials)
                        if(!SessionManager.shared.store(credentials: credentials)) {
                            print("Failed to store credentials")
                        } else {
                            SessionManager.shared.retrieveProfile { error in
                                DispatchQueue.main.async {
                                    if error != nil  {
                                        print("Failed to retrieve profile: \(String(describing: error))")
                                    }
                                    self.performSegue(withIdentifier: "ShowProfile", sender: nil)
                                }
                            }
                        }
                    case .failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    fileprivate func performTwitterAuthentication() {
        self.view.endEditing(true)
        self.loading = true
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .audience("https://" + clientInfo.domain + "/userinfo")
            .connection("twitter")
            .scope("openid profile email")
            .start { result in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    switch result {
                    case .success(let credentials):
                        
                        self.loginWithCredentials(credentials)
                        if(!SessionManager.shared.store(credentials: credentials)) {
                            print("Failed to store credentials")
                        } else {
                            SessionManager.shared.retrieveProfile { error in
                                DispatchQueue.main.async {
                                    if error != nil  {
                                        print("Failed to retrieve profile: \(String(describing: error))")
                                    }
                                    self.performSegue(withIdentifier: "ShowProfile", sender: nil)
                                }
                            }
                        }
                    case .failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    fileprivate func performGoogleAuthentication() {
        self.view.endEditing(true)
        self.loading = true
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .audience("https://" + clientInfo.domain + "/userinfo")
            .connection("google-oauth2")
            .scope("openid profile email")
            .start { result in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    switch result {
                    case .success(let credentials):
                        
                        self.loginWithCredentials(credentials)
                        if(!SessionManager.shared.store(credentials: credentials)) {
                            print("Failed to store credentials")
                        } else {
                            SessionManager.shared.retrieveProfile { error in
                                DispatchQueue.main.async {
                                    if error != nil  {
                                        print("Failed to retrieve profile: \(String(describing: error))")
                                    }
                                    self.performSegue(withIdentifier: "ShowProfile", sender: nil)
                                }
                            }
                        }
                    case .failure(let error):
                        self.showAlertForError(error)
                    }
                }
        }
    }
    
    fileprivate func loginWithCredentials(_ credentials: Credentials) {
        self.retrievedCredentials = credentials
       // self.performSegue(withIdentifier: "ShowProfile", sender: nil)
    }
    
}
    
