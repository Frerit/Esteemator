//
//  FormulaZeroView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 8/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import TextFieldEffects
import BubbleTransition
import FirebaseDatabase

class FormulaZeroView: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var productCost: HoshiTextField!
    @IBOutlet weak var desiredMarge: HoshiTextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var saveFormulas: UIButtonR!
    
    // Formula Gratuita
    var sales: Double!
    var minCostSales: Double!
    
    var margeNeto: Double!
    var merge:Double!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveFormulas.alpha = 0.5
        
    }
    
    /* Formula free */
    func saleWithDesiredRange(totalCost: Double, desiredRange: Double, type:String?=nil) -> (total:Double, range:Double)? {
        var range:Double = 0.0
        let margenFormatted: Double = 1 - Double(desiredRange) / 100
        let result:Double = Double(totalCost) / margenFormatted
        if type == "test" {
            range = result - totalCost
            return (result, Double(range))
        }
        return (result, range)
    }
    
    
    @IBAction func calculateFormulaZero(_ sender: UIButton) {
        if self.productCost.text != "" &&  self.desiredMarge.text != "" {
            let parsedCost = Double(self.productCost.text!)!
            let desiredRangeParsed = Double(self.desiredMarge.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"  {
                let result = self.saleWithDesiredRange(totalCost: parsedCost , desiredRange: desiredRangeParsed )
                resultLabel.text = utility.numberFormat(baseNumber: (result?.total)!)
                saveFormulas.alpha = 1
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test" {
                let parsedCost = Double(self.productCost.text!)!
                let desiredRangeParsed = Double(self.desiredMarge.text!)!
                let result = self.saleWithDesiredRange(totalCost: parsedCost, desiredRange: desiredRangeParsed, type: "test")
                self.saveFormulas.alpha = 1
                self.sales = (result?.total)!
                self.margeNeto = desiredRangeParsed
                self.minCostSales = parsedCost
                self.merge = self.sales - self.minCostSales
                
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: {
                self.productCost.jitter(); self.desiredMarge.jitter()
            })
        }
    }
    @IBAction func saveFormulaList(_ sender: AnyObject) {
        if saveFormulas.alpha == 1 {
            let alert = UIAlertController(title: "Guardar Formula", message: "Colocale un nombre para identificar esta formula", preferredStyle: .alert)
            alert.addTextField { (textField) in textField.placeholder = "Ejm: Producto Nuevo" }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(textField!.text!)")
                if textField?.text != "" {
                    APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Guardando", presentingView: self.view)
                    let parsedCost = Double(self.productCost.text!)!
                    let desiredRangeParsed = Double(self.desiredMarge.text!)!
                    let result = self.saleWithDesiredRange(totalCost: parsedCost, desiredRange: desiredRangeParsed, type: "test")
                    self.saveFormulas.alpha = 1
                    self.sales = (result?.total)!
                    self.margeNeto = desiredRangeParsed
                    self.minCostSales = parsedCost
                    self.merge = self.sales - self.minCostSales
                    
                    if let user = FIRAuth.auth()?.currentUser {
                        self.ref.child("users")
                            .child(user.uid)
                            .child("Formulas")
                            .childByAutoId()
                            .setValue(["name":(textField?.text!)!,
                                       "sales":self.sales,
                                       "marge-neto":self.margeNeto,
                                       "minCost": self.minCostSales,
                                       "marge": self.merge,
                                       "formula":"Free"
                                ])
                    }
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.productCost.text = ""
                        self.desiredMarge.text = ""
                        self.resultLabel.text = "$0"
                        self.saveFormulas.alpha = 0.5
                    })
                } else {
                    self.present(alert!, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Completa la Formula para poder guardarla", presentingView: self.view, completion: nil)
        }
    }
    
    func sendtoModal(views:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objectView = storyboard.instantiateViewController(withIdentifier: views) as? CustomModalTest
        objectView?.transitioningDelegate = self
        objectView?.modalPresentationStyle = .custom
        objectView?.tipoPrueba = "Zero"
        objectView?.sales = sales
        objectView?.minCostSales = minCostSales
        objectView?.marge = merge
        
        DispatchQueue.main.async {
            self.present(objectView!, animated: true, completion: nil)
        }
    }
    
    
    // Para animar el modal
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.view.frame.width / 2, y: transitionButton.frame.origin.y + 150)
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.view.frame.width / 2, y: transitionButton.frame.origin.y + 150)
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    
    
}
