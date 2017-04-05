//
//  ContentPageViewController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 5/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit

class ContentPageViewController: UIViewController {

    @IBOutlet weak var imagenPageView: UIImageView!
    @IBOutlet weak var contentPage: UILabel!
    
    var pageIndex: Int!
    var titleIndex: String!
    var imagefile: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagenPageView.image = UIImage(named: self.imagefile)
        self.contentPage.text = self.titleIndex
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
