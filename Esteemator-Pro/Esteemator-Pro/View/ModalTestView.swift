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
        
        cell?.titleLabel?.text = self.datasend[0][indexPath.row] as? String
        let datoNum = utility.numberFormat(baseNumber: self.datasend[1][indexPath.row] as! Double )
        cell?.priceLabel?.text = datoNum
        return cell!
    }
    
}

class CellCustomice: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
