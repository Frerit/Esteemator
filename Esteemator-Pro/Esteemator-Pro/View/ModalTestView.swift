//
//  ModalTestView.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 10/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit

class ModalTestView: UITableViewController {
    
  
    // Formula 1
    var datasend:[Array<Any>]! = [[""],[0.0]]
    
    let utility = FormulasUtility()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
        tableView.reloadData()
        print(self.datasend)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datasend[0].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result") as? CellCustomice
        let dataPrice = self.datasend[1][indexPath.row] as! Double
        if dataPrice == 0.0 {
            cell?.priceLabel?.text = " "
            cell?.titleLabel.text = ""
            cell?.sectionTitle.alpha = 1
            cell?.sectionTitle?.text = self.datasend[0][indexPath.row] as? String
        } else {
            let datoNum = utility.numberFormat(baseNumber: dataPrice)
            cell?.priceLabel?.text = datoNum
            cell?.titleLabel?.text = self.datasend[0][indexPath.row] as? String
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataPrice = self.datasend[1][indexPath.row] as! Double
        var size:CGFloat = 56
        if dataPrice == 0.0 {  size = 40  }
        return size
    }
    
}



class CellCustomice: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sectionTitle: UILabel!
}
