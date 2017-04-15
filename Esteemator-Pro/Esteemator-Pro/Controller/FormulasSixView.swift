//
//  FormulasSixView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 12/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import TextFieldEffects
import FirebaseDatabase
import BubbleTransition

class FormulasSixView: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var averageSalesByUnity: HoshiTextField!
    @IBOutlet weak var averageGrossMargin: HoshiTextField!
    @IBOutlet weak var discountPercentage: HoshiTextField!
    @IBOutlet weak var unityPricePreDiscount: HoshiTextField!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var secondFormulaResult: UILabel!
    @IBOutlet weak var thirdFormulaResult: UILabel!
    @IBOutlet weak var transitionButton: UIButtonR!
    @IBOutlet weak var saveFormules: UIButtonR!
    @IBOutlet weak var scrolView: UIScrollView!
    
    var cost:Double!
    var margeNeto:Double!
    var porcentDiscont:Double!
    var priceBefore:Double!
    var thresholdForDiscount:Double!
    var unityNewPrice:Double!
    var unityCost:Double!

    var salesBefore:Double!
    var minCostBefore:Double!
    var grosMarginBef:Double!
    var salesAfter:Double!
    var minCostAff:Double!
    var grosMarginAff:Double!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveFormules.alpha = 0.5
         self.scrolView.contentSize = CGSize(width: self.view.frame.width, height: 720)
        // Do any additional setup after loading the view.
    }
    
    /* Formula Six */
    func salesThresholdForADiscount(averageSalesByUnity: Double, averageGrossMargin: Double, discountPercentage: Double, unityPricePreDiscount: Double) -> (thresholdForDiscount: Double, unityNewPrice: Double, unityCost: Double) {
        var tempValue = (discountPercentage / 100) / ((averageGrossMargin / 100) - (discountPercentage / 100))
        tempValue = tempValue * 1
        tempValue = tempValue * averageSalesByUnity
        let thresholdForDiscount = tempValue + averageSalesByUnity
        var unityNewPrice = 1 - (discountPercentage / 100)
        unityNewPrice = unityPricePreDiscount * unityNewPrice
        var unityCost =  1 - (averageGrossMargin / 100)
        unityCost = unityPricePreDiscount * unityCost
        return(thresholdForDiscount, unityNewPrice, unityCost)
    }
   
    @IBAction func calculateFormulaSix(_ sender: AnyObject) {
        if averageGrossMargin.text != "" && averageSalesByUnity.text != "" && discountPercentage.text != "" && unityPricePreDiscount.text != "" {
            let parsedUnitySales = Double(self.averageSalesByUnity.text!)!
            let parsedAverageGrossMargin = Double(self.averageGrossMargin.text!)!
            let discountPercent = Double(self.discountPercentage.text!)!
            let unityPricePreDiscount = Double(self.unityPricePreDiscount.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"   {
                let result = self.salesThresholdForADiscount(averageSalesByUnity: parsedUnitySales, averageGrossMargin: parsedAverageGrossMargin, discountPercentage: discountPercent, unityPricePreDiscount: unityPricePreDiscount)
                
                resultFormula.text = utility.numberFormat(baseNumber: result.thresholdForDiscount)
                secondFormulaResult.text = utility.numberFormat(baseNumber: result.unityNewPrice)
                thirdFormulaResult.text = utility.numberFormat(baseNumber: result.unityCost)
                
                cost = parsedUnitySales
                margeNeto = parsedAverageGrossMargin
                porcentDiscont = discountPercent
                priceBefore = unityPricePreDiscount
                thresholdForDiscount =  result.thresholdForDiscount
                unityNewPrice = result.unityNewPrice
                unityCost = result.unityCost
                
                salesBefore = unityNewPrice * thresholdForDiscount
                minCostBefore = unityCost * thresholdForDiscount
                grosMarginBef = salesBefore - minCostBefore
                
                salesAfter = priceBefore * cost
                minCostAff =  unityCost * cost
                grosMarginAff = salesAfter - minCostAff
                
            } else if  sender.currentTitle == "Prueba" || sender.currentTitle == "Test" {
                self.saveFormules.alpha = 1
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")
            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: {
                self.averageSalesByUnity.jitter()
                self.averageGrossMargin.jitter()
                self.discountPercentage.jitter()
                self.unityPricePreDiscount.jitter()
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
                    }
                    APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "OK", duration: 1.0, presentingView: self.view, completion: {
                        self.averageGrossMargin.text = ""
                        self.averageGrossMargin.text = ""
                        self.discountPercentage.text = ""
                        self.unityPricePreDiscount.text = ""
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
        vc?.tipoPrueba = "6"
        vc?.salesBefore = salesBefore
        vc?.minCostBefore = minCostBefore
        vc?.grosMarginBef = grosMarginBef
        vc?.salesAfter = salesAfter
        vc?.minCostAff = minCostAff
        vc?.grosMarginAff = grosMarginAff
        
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
