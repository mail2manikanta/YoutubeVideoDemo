//
//  ViewController.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class ViewController: UIViewController {
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    let signInButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        
        //Update constraints for SignIn button to position it to center of the view controller
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Fix the width and height of the signInButton
        signInButton.widthAnchor.constraint(equalToConstant: Constants.signInButtonWidth).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: Constants.signInButtonHeight).isActive = true
    }
}

extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            // Unable to authenticate, wrong credentials
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            return
        }
        // Sign in successful, navigate to VideoSearch screen
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let videoListViewController = storyBoard.instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController {
            videoListViewController.setUser(user: user)
            self.navigationController?.pushViewController(videoListViewController, animated: false)
        }
    }
}
