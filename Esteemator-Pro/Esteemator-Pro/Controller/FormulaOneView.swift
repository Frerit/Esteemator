//
//  FormulaOneView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 11/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import TextFieldEffects
import FirebaseDatabase
import BubbleTransition


class FormulaOneView: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var producTotalCost: HoshiTextField!
    @IBOutlet weak var desiredRange: HoshiTextField!
    @IBOutlet weak var operationalExpenses: HoshiTextField!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var saveFormules: UIButtonR!
    @IBOutlet weak var transitionButton: UIButtonR!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    
    // Formulas One
    var minCostSales:Double!
    var sales:Double!
    var margeNeto:Double!
    var marge:Double!
    var minCostExpen:Double!
    var opeExpenses:Double!
    var beforeImp:Double!
    
    // Firebase
    let ref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveFormules.alpha = 0.5
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Formula two */
    func saleWithDesiredRangeOperationExpenses(totalCost: Double, desiredRange: Double, operationalExpenses: Double, type:String?=nil) -> (Double) {
        let deductionFormatted: Double = 1 - (Double(desiredRange) / 100) - (Double(operationalExpenses) / 100)
        let result:Double = Double(totalCost) / deductionFormatted
        return result
    }
    
    @IBAction func calculateFormulaOne(_ sender: UIButton) {
        if self.producTotalCost.text != "" && self.desiredRange.text != "" && self.operationalExpenses.text != ""  {
            let parsedCost = Double(self.producTotalCost.text!)!
            let parsedRange = Double(self.desiredRange.text!)!
            let parsedExpense = Double(self.operationalExpenses.text!)!
            
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"   {
                let result = saleWithDesiredRangeOperationExpenses(totalCost: parsedCost , desiredRange: parsedRange , operationalExpenses: parsedExpense)
                resultFormula.text = utility.numberFormat(baseNumber: result)
                self.saveFormules.alpha = 1
                minCostSales = parsedCost
                sales = result
                margeNeto = parsedRange
                opeExpenses = parsedExpense
                
                let _grossMargin = sales - minCostSales
                let _costExpenses = sales * opeExpenses / 100
                let _utilityBeforeImp = _grossMargin - _costExpenses
                
                marge = _grossMargin
                minCostExpen = _costExpenses
                beforeImp = _utilityBeforeImp
                
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test" {
                self.saveFormules.alpha = 1
                
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: { 
                self.producTotalCost.jitter(); self.desiredRange.jitter(); self.operationalExpenses.jitter()
                self.resultFormula.text = "0"
                self.saveFormules.alpha = 0.5
            })
        }
    }
    
    @IBAction func saveFormulasList(_ sender: AnyObject) {
        if self.producTotalCost.text != "" && self.desiredRange.text != "" && self.operationalExpenses.text != "" {
            self.saveFormules.alpha = 0.5
        }
            
        if saveFormules.alpha == 1 {
            let alert = UIAlertController(title: "Guardar Formula", message: "Colocale un nombre para identificar esta formula", preferredStyle: .alert)
            alert.addTextField { (textField) in textField.placeholder = "Ejm: Producto Nuevo" }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(textField!.text!)")
                if textField?.text != "" {
                    APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Guardando", presentingView: self.view)
                    if let user = FIRAuth.auth()?.currentUser {
                        self.ref.child("users")
                            .child(user.uid)
                            .child("Formulas")
                            .childByAutoId()
                            .setValue(["name": (textField?.text!)!,
                                       "sales": self.sales,
                                       "marge-neto": self.margeNeto,
                                       "minCost":self.minCostSales,
                                       "opeExpenses":self.opeExpenses,
                                       "beforeImp":self.beforeImp,
                                       "formula":"1"])
                        
                    }
                   
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.producTotalCost.text = ""
                        self.desiredRange.text = ""
                        self.operationalExpenses.text = ""
                        
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
        let vc = storyboard.instantiateViewController(withIdentifier: views) as? CustomModalTest
        vc?.transitioningDelegate = self
        vc?.modalPresentationStyle = .custom
        vc?.tipoPrueba = "1"
        vc?.sales = sales
        vc?.minCostSales = minCostSales
        vc?.marge = marge
        vc?.minCostExpen = minCostExpen
        vc?.beforeImp = beforeImp
        
        DispatchQueue.main.async {
            self.present(vc!, animated: true, completion: nil)
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
