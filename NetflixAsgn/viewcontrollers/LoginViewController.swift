//
//  LoginViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIView!
    
    var requestToken: String = ""
    
    var username: String?
    var profile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequestToken()
        
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btnLogin.layer.borderWidth = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickLogin))
        
        btnLogin.isUserInteractionEnabled = true
        btnLogin.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func onClickLogin(){
        print("login")
        
        let email:String = txtEmail.text ?? ""
        let password: String = txtPassword.text ?? ""
        requestLogin(email: email, password: password) { (requestToken) in
            self.requestSession(requestToken: requestToken, completion: { [weak self] sessionId in
                DispatchQueue.main.async {
                    self?.hidesBottomBarWhenPushed = false
    //                    self?.present(profileVC, animated: true, completion: nil)

                    self?.performSegue(withIdentifier: "HomeNavigationViewSegue", sender: self)
                }
            })
            
        }
        
    }
    
    fileprivate func getRequestToken(){
        UserModel.shared.getRequestToken { [weak self] requestToken in
            DispatchQueue.main.async {
                self?.requestToken = requestToken
            }
        }
        
    }
    
    
    fileprivate func requestLogin(email: String, password: String, completion : @escaping (String) -> Void){
        UserModel.shared.requestLogin(email: email, password: password, requestToken: requestToken) { (requestToken) in
            self.requestToken = requestToken
            print("requestToken with form data \(requestToken)")
            completion(requestToken)
        }
    }
    
    fileprivate func requestSession(requestToken: String, completion : @escaping (String) -> Void){

        UserModel.shared.requestCreateSession(requestToken: requestToken) { sessionId in
            UserDefaults.standard.set(sessionId, forKey: "token")
            print("Session Id \(sessionId)")
            completion(sessionId)
        }
        
    }
    
}
