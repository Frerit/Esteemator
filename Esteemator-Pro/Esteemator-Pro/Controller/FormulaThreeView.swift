//
//  FormulaThreeView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 12/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import FirebaseDatabase
import BubbleTransition
import TextFieldEffects

class FormulaThreeView: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var operationalExpenses: HoshiTextField!
    @IBOutlet weak var averageGrossMargin: HoshiTextField!
    @IBOutlet weak var priceByUnit: HoshiTextField!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var secondFormulaResult: UILabel!
    @IBOutlet weak var transitionButton: UIButtonR!
    @IBOutlet weak var saveFormulas: UIButtonR!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    var ref = FIRDatabase.database().reference()
    
    var minCostSales:Double!
    var sales:Double!
    var minCostExpen:Double!
    var margeNeto:Double!
    var marge:Double!
    var priceByUnity:Double!
    var breakeven:Double!
    var beforeImp:Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveFormulas.alpha = 0.5
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 570)
        // Do any additional setup after loading the view.
    }
    
    func breakevenByValue(totalExpenses: Double, averageGrossMargin: Double) -> Double {
        let breakeven_value = totalExpenses / (Double(averageGrossMargin) / 100)
        return breakeven_value
    }
    /* Formula three */
    func breakevenByUnit(totalExpenses: Double, averageGrossMargin: Double, unitAvaragePrice: Double) -> (breakeven: Double, breakevenUnit: Int) {
        let breakeven = breakevenByValue(totalExpenses: totalExpenses, averageGrossMargin: averageGrossMargin)
        let breakevenUnitTotal =  breakeven / unitAvaragePrice
        return ( breakeven, Int(breakevenUnitTotal))
        
    }
    
    @IBAction func calculateFormulaThree(_ sender: UIButton) {
        
        if operationalExpenses.text != "" && averageGrossMargin.text != "" && priceByUnit.text != "" {
            let parsedExpense = Double(self.operationalExpenses.text!)!
            let parsedAverageGrossMargin = Double(self.averageGrossMargin.text!)!
            let parsedpriceByUnit = Double(self.priceByUnit.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"   {
                let result = self.breakevenByUnit(totalExpenses: parsedExpense, averageGrossMargin: parsedAverageGrossMargin, unitAvaragePrice: parsedpriceByUnit)
                resultFormula.text = utility.numberFormat(baseNumber: result.breakeven)
                secondFormulaResult.text = String(result.breakevenUnit)
                sales = result.breakeven
                minCostExpen = parsedExpense
                margeNeto = parsedAverageGrossMargin
                priceByUnity = parsedpriceByUnit
                breakeven = Double(result.breakevenUnit)
                
                let _minCostSale = sales * (1 - margeNeto / 100)
                let _grossMargin = sales - _minCostSale
                let _utilityBeforeImp = _grossMargin - minCostExpen
                
                minCostSales = _minCostSale
                marge = _grossMargin
                beforeImp = abs(_utilityBeforeImp)
                
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test" {
                self.saveFormulas.alpha = 1
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: { 
                self.operationalExpenses.jitter(); self.averageGrossMargin.jitter(); self.priceByUnit.jitter()
                self.resultFormula.text = "0"
                self.saveFormulas.alpha = 0.5
            })
        }

    }
    
    @IBAction func saveFormulasList(_ sender: AnyObject) {
        if saveFormulas.alpha == 1 {
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
                                   "operacionaExpe":self.minCostExpen,
                                   "marge-neto":self.margeNeto,
                                   "pricebyUni":self.priceByUnity,
                                   "sales":self.sales,
                                   "mincosSales":self.minCostSales,
                                   "marge":self.marge,
                                   "breakeven":self.breakeven,
                                   "beforeImp":self.beforeImp])
                    }
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.operationalExpenses.text = ""
                        self.averageGrossMargin.text = ""
                        self.priceByUnit.text = ""
                        self.resultFormula.text = "$0"
                        self.secondFormulaResult.text = "$0"
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
        vc?.tipoPrueba = "3"
        vc?.sales = sales
        vc?.minCostSales = minCostSales
        vc?.marge = marge
        vc?.minCostExpen = minCostExpen
        vc?.beforeImp = beforeImp
        vc?.priceByUnity = priceByUnity
        vc?.breakeven = breakeven
        
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
