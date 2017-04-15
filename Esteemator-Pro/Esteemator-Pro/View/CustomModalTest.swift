//
//  CustomModalTest.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 10/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit


class CustomModalTest: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    var tipoPrueba: String = ""
    
    // Formula Free
    var sales:Double! = 0.0
    var minCostSales:Double! = 0.0
    var marge:Double! = 0.0
    
    // Formula 1
    var margeNeto:Double!
    var minCostExpen:Double!
    var opeExpenses:Double!
    var beforeImp:Double!
    
    // Formula 3
    var priceByUnity:Double!
    var breakeven:Double!
    var royaltiesValue:Double!
    
    // Formula 6
    var salesBefore:Double!
    var minCostBefore:Double!
    var grosMarginBef:Double!
    var salesAfter:Double!
    var minCostAff:Double!
    var grosMarginAff:Double!

    
    
    // Titles 
    let titleSales =        "Ventas"
    let titleMinCost =      "Menos costo mercancía vendida"
    let titleMarget =       "Margen"
    let titleMargeB =       "Margen Bruto"
    let titleOpeExpen =     "Menos gastos operacioneles"
    let titleBeforeImp =    "Utilidad Neta antes de Int. E Impuestos"
    let titlepriceByUni =   "Precio Promedio de cada Unidad"
    let titleBreakeven =    "Punto de Equilibrio en Unidades"
    let titleRoyalties =    "Menos Royalties por Franquicias"
    
    let titleBefor =        "Despues de otorgar el descuento"
    let titleAffter =       "Antes de otorgar el descuento"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModalTest(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = segue.destination as? ModalTestView
        if tipoPrueba == "Zero" {
            data?.datasend = [[titleSales,titleMinCost,titleMarget],
                              [self.sales,self.minCostSales,self.marge]]

        } else if tipoPrueba == "1" {
            data?.datasend = [[titleSales,titleMinCost,titleMargeB,titleOpeExpen,titleBeforeImp],
                              [self.sales,self.minCostSales, self.marge, self.minCostExpen, self.beforeImp]]
            
        } else if tipoPrueba == "2" {
            data?.datasend = [[titleSales,titleMinCost,titleMargeB,titleOpeExpen,titleBeforeImp],
                              [self.sales,self.minCostSales, self.marge, self.minCostExpen, self.beforeImp]]
            
        } else if tipoPrueba == "3" {
            data?.datasend = [[titleSales,titleMinCost,titleMargeB,titleOpeExpen,titleBeforeImp,titlepriceByUni,titleBreakeven],
                            [self.sales,self.minCostSales, self.marge, self.minCostExpen, self.beforeImp,self.priceByUnity,self.breakeven]]
        } else if tipoPrueba == "4" {
            data?.datasend = [[titleSales,titleMinCost,titleMargeB,titleOpeExpen,titleBeforeImp],
                              [self.sales,self.minCostSales, self.marge, self.minCostExpen, self.beforeImp]]
            
        } else if tipoPrueba == "5" {
            data?.datasend = [[titleSales,titleMinCost,titleMargeB,titleOpeExpen,titleRoyalties,titleBeforeImp],[self.sales,self.minCostSales, self.marge, self.minCostExpen,self.royaltiesValue, self.beforeImp]]
        } else if tipoPrueba == "6" ||
                  tipoPrueba == "7" {
              data?.datasend = [[titleBefor,titleSales,titleMinCost,titleMargeB,
                                 titleAffter,titleSales,titleMinCost,titleMargeB],
                                [0.0,self.salesBefore,self.minCostBefore, self.grosMarginBef,
                                 0.0,self.salesAfter,self.minCostAff, self.grosMarginAff]]        }
    }
    
}
