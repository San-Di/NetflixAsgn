//
//  ProfileViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/10/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController {

    @IBOutlet weak var imgProfileAvata: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    let sessionId = UserDefaults.standard.object(forKey: "token") as? String
    var username: String?
    var profileHash : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let name = username
//            lblUsername.text = name
//        }
//
//        if let profile = profileHash{
//            imgProfileAvata.sd_setImage(with: URL(string: profile), completed: nil)
//            //https://www.gravatar.com/avatar/cbf499e5669eac08289e1e10d567f7ad
//        }
//
        getAccountDetail(sessionId: sessionId ?? "")
    }
   

    
    fileprivate func getAccountDetail(sessionId: String){
        UserModel.shared.getAccountDetail(sessionId: sessionId) { [weak self] account in
            DispatchQueue.main.async {
                self?.lblUsername.text = account.username
                self?.imgProfileAvata.sd_setImage(with: URL(string: API.BASE_IMG_URL + account.avatar.gravatar.hash), completed: nil)
            }
        }
    }
}
