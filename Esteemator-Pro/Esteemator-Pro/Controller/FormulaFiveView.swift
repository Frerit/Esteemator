//
//  FormulaFiveView.swift
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

class FormulaFiveView: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var operationalExpenses: HoshiTextField!
    @IBOutlet weak var averageGrossMargin: HoshiTextField!
    @IBOutlet weak var desiredUtility: HoshiTextField!
    @IBOutlet weak var valueRoyalties: HoshiTextField!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var transitionButton: UIButtonR!
    @IBOutlet weak var saveFormules: UIButtonR!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    var ref = FIRDatabase.database().reference()
    
    var sales:Double!
    var cost:Double!
    var margeNeto:Double!
    var minCostSales:Double!
    var minCostExpen:Double!
    var desiredUtily:Double!
    var marge:Double!
    var royaltiesValue:Double!
    var minRoyalties:Double!
    var beforeImp:Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 670)
        self.saveFormules.alpha = 0.5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*Formula Five*/
    
    func salesWithUtilityPayingRoyalties(totalExpenses: Double, averageGrossMargin: Double, saleUtilityDesired:Double, royaltiesValue: Double) -> Double {
        let budgetedPercentage = (averageGrossMargin / 100) - (saleUtilityDesired / 100) - (royaltiesValue / 100)
        let budgetedSalesRoyalties = totalExpenses / budgetedPercentage
        return budgetedSalesRoyalties
    }

    
    @IBAction func calculateFormulaFive(_ sender: UIButton) {
        if operationalExpenses.text != "" && averageGrossMargin.text != "" && desiredUtility.text != "" && valueRoyalties.text != "" {
            let parsedExpense = Double(self.operationalExpenses.text!)!
            let parsedAverageGrossMargin = Double(self.averageGrossMargin.text!)!
            let parsedDesiredUtility = Double(self.desiredUtility.text!)!
            let parsedRoyaltiesValue = Double(self.valueRoyalties.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"    {
                let result = self.salesWithUtilityPayingRoyalties(totalExpenses: parsedExpense, averageGrossMargin: parsedAverageGrossMargin, saleUtilityDesired: parsedDesiredUtility, royaltiesValue: parsedRoyaltiesValue)
                resultFormula.text = utility.numberFormat(baseNumber: result)
                self.saveFormules.alpha = 1
                sales = result
                cost = parsedExpense
                margeNeto = parsedAverageGrossMargin
                desiredUtily = parsedDesiredUtility
                royaltiesValue = parsedRoyaltiesValue
                
                let _minCostSale = sales * (1 - margeNeto / 100)
                let _grossMargin = sales - _minCostSale
                let _minRoyalties = sales * royaltiesValue / 100
                let _utilityBeforeImp = _grossMargin - cost - _minRoyalties
                
                minCostSales = _minCostSale
                marge = _grossMargin
                minRoyalties = _minRoyalties
                beforeImp = _utilityBeforeImp
                
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test" {
                self.saveFormules.alpha = 1
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: {
                self.operationalExpenses.jitter()
                self.averageGrossMargin.jitter()
                self.desiredUtility.jitter()
                self.valueRoyalties.jitter()
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
                                       "RoyalFranqui":self.royaltiesValue,
                                       "desiredUtility":self.desiredUtily,
                                       "sales":self.sales,
                                       "mincosSales":self.minCostSales,
                                       "merge":self.marge,
                                       "royalties":self.minRoyalties,
                                       "beforeImp":self.beforeImp
                                ])
                    }
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.operationalExpenses.text = ""
                        self.averageGrossMargin.text = ""
                        self.desiredUtility.text = ""
                        self.valueRoyalties.text = ""
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
        vc?.tipoPrueba = "5"
        vc?.sales = sales
        vc?.minCostSales = minCostSales
        vc?.marge = marge
        vc?.minCostExpen = cost
        vc?.royaltiesValue = minRoyalties
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
