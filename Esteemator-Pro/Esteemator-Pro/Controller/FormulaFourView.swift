//
//  FormulasFourView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 12/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import BubbleTransition
import FirebaseDatabase
import TextFieldEffects

class FormulaFourView: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var operationalExpenses: HoshiTextField!
    @IBOutlet weak var averageGrossMargin: HoshiTextField!
    @IBOutlet weak var desiredUtility: HoshiTextField!
    @IBOutlet weak var transitionButton: UIButtonR!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var saveFormules: UIButtonR!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    var ref = FIRDatabase.database().reference()
    
    var sales:Double!
    var cost:Double!
    var margeNeto:Double!
    var minCostSales:Double!
    var desiredUtily:Double!
    var marge:Double!
    var beforeImp:Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Formula Four*/
    
    func salesWithUtility(totalExpenses: Double, averageGrossMargin: Double, saleUtilityDesired: Double) -> Double {
        let budgetedPercentage = (averageGrossMargin / 100) - (saleUtilityDesired / 100)
        let budgetedSales = totalExpenses / budgetedPercentage
        return budgetedSales
    }
    
    @IBAction func calculateFormulaFour(_ sender: AnyObject) {
        if operationalExpenses.text != "" && averageGrossMargin.text != "" && desiredUtility.text != "" {
            let parsedExpense = Double(self.operationalExpenses.text!)!
            let parsedAverageGrossMargin = Double(self.averageGrossMargin.text!)!
            let parsedDesiredUtility = Double(self.desiredUtility.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"   {
                let result = self.salesWithUtility(totalExpenses: parsedExpense, averageGrossMargin: parsedAverageGrossMargin, saleUtilityDesired: parsedDesiredUtility)
                resultFormula.text = utility.numberFormat(baseNumber: result)
                
                sales = result
                cost = parsedExpense
                margeNeto = parsedAverageGrossMargin
                desiredUtily = parsedDesiredUtility
                
                let _minCostSale = sales * (1 - margeNeto / 100)
                let _grossMargin = sales - _minCostSale
                let _utilityBeforeImp = _grossMargin - cost
                
                minCostSales = _minCostSale
                marge = _grossMargin
                beforeImp = abs(_utilityBeforeImp)
                
                
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test"  {
                self.saveFormules.alpha = 1
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: {
                self.operationalExpenses.jitter(); self.averageGrossMargin.jitter(); self.desiredUtility.jitter()
                self.resultFormula.text = "0"
                self.saveFormules.alpha = 0.5
            })
        }
    }
    
    @IBAction func saveFormulasList(_ sender: AnyObject) {
        if saveFormules.alpha == 1 {
            let alert = UIAlertController(title: "Guardar Formula", message: "Colocale un nombre para identificar esta formula", preferredStyle: .alert)
            alert.addTextField { (textField) in textField.placeholder = "Ejm: Producto Nuevo" }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(textField!.text!)")
                if textField?.text != "" {
                    APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Guardando", presentingView: self.view)
                    if let user = FIRAuth.auth()?.currentUser  {
                        self.ref.child("users")
                        .child(user.uid)
                        .child("Formulas")
                        .childByAutoId()
                        .setValue(["name":(textField?.text!)!,
                                 "marge-neto":self.margeNeto,
                                 "minCostExpen":self.cost,
                                 "desiredUtility":self.desiredUtily,
                                 "sales":self.sales,
                                 "mincosSales":self.minCostSales,
                                 "merge":self.marge,
                                 "beforeImp":self.beforeImp
                                ])
                    }
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.operationalExpenses.text = ""
                        self.averageGrossMargin.text = ""
                        self.desiredUtility.text = ""
                        self.resultFormula.text = "$0"
                    })
                } else {  self.present(alert!, animated: true, completion: nil)     }
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
        vc?.tipoPrueba = "4"
        vc?.sales = sales
        vc?.minCostSales = minCostSales
        vc?.marge = marge
        vc?.minCostExpen = cost
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
