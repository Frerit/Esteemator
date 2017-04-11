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
    
    
    // Titles 
    let titleSales =        "Ventas"
    let titleMinCost =      "Menos costo mercancía vendida"
    let titleMarget =       "Margen"
    let titleMargeB =       "Margen Bruto"
    let titleOpeExpen =     "Menos gastos operacioneles"
    let titleBeforeImp =    "Utilidad Neta antes de Int. E Impuestos"
    
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
        }
    }
    
}
