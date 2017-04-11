//
//  LoginVController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 6/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import FBSDKLoginKit
import FirebaseDatabase
import TextFieldEffects

class LoginVController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {


    @IBOutlet weak var logginButton: UIButton!
    @IBOutlet weak var contentBottonGoogle: UIView!
    @IBOutlet weak var buttonIngreso: UIButton!
    @IBOutlet weak var contenButtonFacebook: UIView!
    
    // Login sin redes
    @IBOutlet weak var userEmail: HoshiTextField!
    @IBOutlet weak var userPassword: HoshiTextField!
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Button Google
        self.contentBottonGoogle.layer.cornerRadius = 3
        self.logginButton.layer.cornerRadius = 3
        self.buttonIngreso.layer.cornerRadius = 3
        self.contenButtonFacebook.layer.cornerRadius = 3
        
        
        
        FIRAuth.auth()?.addStateDidChangeListener({ auth, user in
            if (FIRAuth.auth()?.currentUser) != nil {
                if user != nil{
                    self.ref.child("users").child((user?.uid)!).setValue(["nameUser": user!.displayName!,
                                "email":user!.email!,
                                "porvider":"redes"])
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "", presentingView: self.view, completion: {
                        self.sendLoginSucces(views: "ListFormulesView")
                    })
                }
            } else {
               print("Usuario no Logiuado")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FIRAuth.auth()?.currentUser) != nil {
                self.sendLoginSucces(views: "ListFormulesView")
        }
    }
    
    // Login Googl
    
    @IBAction func loginGoogleIn(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Espera por favor", presentingView: self.view)
    }
     
    // Login Face
    
    @IBAction func loginFacebookIn(_ sender: AnyObject) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (user, error) in
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (conection, result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                   
                })
            }
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("se deslogueo")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismisPresenLogin(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logintoEmailPassword(_ sender: AnyObject) {
        if self.userEmail.text != "" && self.userPassword.text != "" {
            APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Espera por favor", presentingView: self.view)
            if validateEmail() {
                FIRAuth.auth()?.signIn(withEmail: self.userEmail.text!, password: self.userPassword.text!, completion: { user, error in
                    if user != nil {
                        APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "", presentingView: self.view, completion: nil)
                        self.sendLoginSucces(views: "ListFormulesView")
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Ingresa tu correo y la contraseña", presentingView: self.view, completion: { 
                self.userEmail.becomeFirstResponder()
            })
        }
    }
    
    func sendLoginSucces(views:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objectView = storyboard.instantiateViewController(withIdentifier: views)
        DispatchQueue.main.async {
            self.present(objectView, animated: true, completion: nil)
        }
    }
    
    
    func validateEmail()  -> Bool{
        let divicion = self.userEmail.text?.components(separatedBy: "@")
        if divicion?.count == 2 {
            let coma = divicion?[1].components(separatedBy: ".")
            if (coma?.count)! >= 2 {  return true
            } else{  APESuperHUD.showOrUpdateHUD(icon: .email, message: "Ingrese correo Valido", duration: 1.0, presentingView: self.view, completion: nil)   }
            let espacio = divicion?[0].contains(" ")
            if (espacio)! {  APESuperHUD.showOrUpdateHUD(icon: .email, message: "El correo no tiene formato valido", duration: 1.0, presentingView: self.view, completion: nil)  }
        } else {  APESuperHUD.showOrUpdateHUD(icon: .email, message: "Ingrese correo Valido", duration: 1.0, presentingView: self.view, completion: nil) }
        return false
    }
}
