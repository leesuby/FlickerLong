//
//  ProfileViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private var profileView: ProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        profileView = ProfileView(viewController: self)
        profileView.initView()
        profileView.initConstraint()
    
    }
    
    override func viewWillLayoutSubviews() {
        profileView.layoutSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update Status User
        Constant.UserSession.currentTab = .profile
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
