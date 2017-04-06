//
//  LoginVController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 6/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase

class LoginVController: UIViewController, GIDSignInUIDelegate {


    @IBOutlet weak var logginButton: UIButton!
    @IBOutlet weak var contentBottonGoogle: UIView!
    @IBOutlet weak var buttonIngreso: UIButton!
    @IBOutlet weak var contenButtonFacebook: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Button Google
        self.contentBottonGoogle.layer.cornerRadius = 3
        self.logginButton.layer.cornerRadius = 3
        self.buttonIngreso.layer.cornerRadius = 3
        self.contenButtonFacebook.layer.cornerRadius = 3
        
    }
   
    @IBAction func loginGoogleIn(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
        
        FIRAuth.auth()?.addStateDidChangeListener({ auth, user in
            if (FIRAuth.auth()?.currentUser) != nil {
                print("Esta logiado")
            } else {
                print("no lo esta")
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismisPresenLogin(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
