//
//  RegisterViewController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 6/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import APESuperHUD
import TextFieldEffects

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameUser: HoshiTextField!
    @IBOutlet weak var lastNameUser: HoshiTextField!
    @IBOutlet weak var emailUser: HoshiTextField!
    @IBOutlet weak var cityUser: HoshiTextField!
    @IBOutlet weak var passwordUser: HoshiTextField!
    
    
    // inicializar Firebase
    
    let ref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismisRegister(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func registerNewUser(_ sender: Any) {
        if self.nameUser.text != "" && self.lastNameUser.text != "" && self.emailUser.text != "" && self.cityUser.text != "" && self.passwordUser.text != "" {
            
            if validateEmail() && (self.passwordUser.text?.lengthOfBytes(using: String.Encoding.utf8))! > 8 {
                APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Espera por favor", presentingView: self.view)
                print("\(self.emailUser.text!) -- \(self.passwordUser.text!)")
                FIRAuth.auth()?.createUser(withEmail: self.emailUser.text!, password: self.passwordUser.text!, completion: { user, error in
                    
                    if user != nil {
                        self.ref.child("users").child((user?.uid)!).setValue(["nameUser":self.nameUser.text!,
                                                                              "lastname":self.lastNameUser.text!,
                                                                              "email":user?.email,
                                                                              "city":self.cityUser.text!
                            ])
                        APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
                        self.sendView(views: "ListFormulesView")
                        
                    } else if (error?.localizedDescription.contains("address is already"))!{
                        APESuperHUD.showOrUpdateHUD(icon: .email, message: "El Correo ya esta registrado", presentingView: self.view, completion: nil)
                    } else {
                      print(error.debugDescription)
                      APESuperHUD.showOrUpdateHUD(icon: .sadFace, message: "No se completo el registro", presentingView: self.view, completion: nil)
                    }
                })
            } else {
                APESuperHUD.showOrUpdateHUD(icon: .info, message:  "Contraseña minimo 8 caracteres entre numeros y letras", presentingView: self.view, completion: {
                    self.passwordUser.becomeFirstResponder()
                })
            }
        } else {
         APESuperHUD.showOrUpdateHUD(icon: .info, message: "No has completado los campos", presentingView: self.view, completion: { 
             self.nameUser.becomeFirstResponder()
         })
        }
     }
    
    
    func sendView(views:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objectView = storyboard.instantiateViewController(withIdentifier: views)
        DispatchQueue.main.async {
            self.present(objectView, animated: true, completion: nil)
        }
    }
    
    
    
    func validateEmail()  -> Bool{
        let divicion = self.emailUser.text?.components(separatedBy: "@")
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
