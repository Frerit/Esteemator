//
//  FormulaSeventView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 15/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit
import Firebase
import APESuperHUD
import TextFieldEffects
import FirebaseDatabase
import BubbleTransition

class FormulaSeventView: UIViewController {
    
    @IBOutlet weak var averageSalesByUnity: HoshiTextField!
    @IBOutlet weak var averageGrossMargin: HoshiTextField!
    @IBOutlet weak var actPricebyUnityDiscount: HoshiTextField!
    @IBOutlet weak var subtotalAct: UILabel!
    @IBOutlet weak var resultFormula: UILabel!
    @IBOutlet weak var secondFormulaResult: UILabel!
    @IBOutlet weak var thirdFormulaResult: UILabel!
    @IBOutlet weak var fourFormulaResul: UILabel!
    @IBOutlet weak var newCostFormulaResult: UILabel!
    @IBOutlet weak var costFormulaResult: UILabel!
    @IBOutlet weak var saveFormules: UIButtonR!
    
    @IBOutlet weak var actPersonal: HoshiTextField!
    @IBOutlet weak var actUniform: HoshiTextField!
    @IBOutlet weak var actCustomerAwars: HoshiTextField!
    @IBOutlet weak var actTastings: HoshiTextField!
    @IBOutlet weak var actoverTimeCharge: HoshiTextField!
    @IBOutlet weak var actAidTransport: HoshiTextField!
    @IBOutlet weak var actFurnitureCost: HoshiTextField!
    @IBOutlet weak var actOther: HoshiTextField!
    
    var utility = FormulasUtility()
    var transition = BubbleTransition()
    
    // Firebase
    var ref = FIRDatabase.database().reference()
    
    var averageSalesByUni:Double!
    var averageGrosMargin:Double!
    var personal:Double!
    var uniform:Double!
    var aidTransport:Double!
    var customersAwars:Double!
    var tastings:Double!
    var overtimeCharge:Double!
    var furnitureCost:Double!
    var otherPrice:Double!
    var priceUnityDiscount:Double!
    
    var salesBefore:Double!
    var minCostBefore:Double!
    var grosMarginBef:Double!
    var salesAfter:Double!
    var minCostAff:Double!
    var grosMarginAff:Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveFormules.alpha = 0.5
        // Do any additional setup after loading the view.
    }
    
    /* Formula Sevent */
    func activityTradeMarketing(
        personal:Double,
        uniform:Double,
        customersAwars:Double,
        tastings:Double,
        overtimeCharge:Double,
        aidTransport:Double,
        furnitureCost:Double,
        averageSalesByUnity:Double,
        averageGrossMargin:Double,
        priceUnityDiscount:Double,
        otherPrice:Double,
        type:String?=nil)
        
        -> (activitiTradeResult:Double,
        salesThresholdForMarketing:Double,
        newSalesThresholdForMarketing:Double,
        percentageForMoney:Double,
        salesThresholdDiscount:Double,
        unityNewPrice:Double,
        unityCost:Double)
    {
        let activitiTradeResult = personal + uniform + customersAwars + tastings + overtimeCharge + aidTransport + furnitureCost + otherPrice
        
        let salesThresholdForMarketing = averageSalesByUnity * priceUnityDiscount
        let newSalesThresholdForMarketing = salesThresholdForMarketing - activitiTradeResult
        var percentageForMoney = activitiTradeResult / salesThresholdForMarketing
        percentageForMoney = percentageForMoney * 100
        var salesThresholdDiscount = (percentageForMoney/100) / ((averageGrossMargin/100) - (percentageForMoney/100))
        salesThresholdDiscount = (salesThresholdDiscount * 1) * averageSalesByUnity
        salesThresholdDiscount = salesThresholdDiscount + averageSalesByUnity
        var unityNewPrice = 1 - percentageForMoney / 100
        unityNewPrice = priceUnityDiscount * unityNewPrice
        var unityCost =  1 - (averageGrossMargin / 100)
        unityCost = priceUnityDiscount * unityCost
        return (activitiTradeResult, salesThresholdForMarketing, newSalesThresholdForMarketing, percentageForMoney, salesThresholdDiscount, unityNewPrice, unityCost)
    }
    
    
    @IBAction func calculateFormulaSeven(_ sender: AnyObject) {
        if averageSalesByUnity.text != "" && averageGrossMargin.text != "" && actPricebyUnityDiscount.text != "" {
            averageSalesByUni = averageSalesByUnity.text != "" ? Double(self.averageSalesByUnity.text!)! : 0.0
            averageGrosMargin = averageGrossMargin.text != "" ? Double(self.averageGrossMargin.text!)! : 0.0
            personal = actPersonal.text != "" ? Double(self.actPersonal.text!)! : 0.0
            uniform = actUniform.text != "" ? Double(self.actUniform.text!)! : 0.0
            aidTransport = actAidTransport.text != "" ? Double(self.actAidTransport.text!)!  : 0.0
            customersAwars = actCustomerAwars.text != "" ? Double(self.actCustomerAwars.text!)! : 0.0
            tastings = actTastings.text != "" ? Double(self.actTastings.text!)! : 0.0
            overtimeCharge = actTastings.text != "" ? Double(self.actoverTimeCharge.text!)! : 0.0
            furnitureCost = actFurnitureCost.text != "" ? Double(self.actFurnitureCost.text!)! : 0.0
            otherPrice = actOther.text != "" ? Double(self.actOther.text!)! : 0.0
            priceUnityDiscount = Double(self.actPricebyUnityDiscount.text!)!
            if sender.currentTitle == "Calcular" || sender.currentTitle == "Calculate"   {
                let result = self.activityTradeMarketing(
                    personal: personal,
                    uniform: uniform,
                    customersAwars: customersAwars,
                    tastings: tastings,
                    overtimeCharge: overtimeCharge,
                    aidTransport: aidTransport,
                    furnitureCost: furnitureCost,
                    averageSalesByUnity: averageSalesByUni,
                    averageGrossMargin: averageGrosMargin,
                    priceUnityDiscount: priceUnityDiscount,
                    otherPrice: otherPrice)
                
                subtotalAct.text = utility.numberFormat(baseNumber: result.activitiTradeResult)
                resultFormula.text = utility.numberFormat(baseNumber: result.salesThresholdForMarketing)
                secondFormulaResult.text = utility.numberFormat(baseNumber: result.newSalesThresholdForMarketing)
                thirdFormulaResult.text = String(result.percentageForMoney)
                fourFormulaResul.text = utility.numberFormat(baseNumber: result.salesThresholdDiscount)
                newCostFormulaResult.text = utility.numberFormat(baseNumber: result.unityNewPrice)
                costFormulaResult.text = utility.numberFormat(baseNumber: result.unityCost)
                
                salesBefore = result.unityNewPrice * result.salesThresholdDiscount
                minCostBefore = result.unityCost * result.salesThresholdDiscount
                grosMarginBef = salesBefore - minCostBefore
                
                salesAfter = priceUnityDiscount * averageSalesByUni
                minCostAff =  result.unityCost * averageSalesByUni
                grosMarginAff = salesAfter - minCostAff
                
            } else if sender.currentTitle == "Prueba" || sender.currentTitle == "Test"  {
                self.saveFormules.alpha = 1
                // ModalViewTestForm
                self.sendtoModal(views: "ModalViewTestForm")

            }
        } else {
            APESuperHUD.showOrUpdateHUD(icon: .info, message: "Faltan campos por completar", presentingView: self.view, completion: {
                self.averageSalesByUnity.jitter()
                self.averageGrossMargin.jitter()
                self.actPricebyUnityDiscount.jitter()
                self.resultFormula.text = "0"
                self.saveFormules.alpha = 0.5
            })
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

    
}
