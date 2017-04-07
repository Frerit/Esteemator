//
//  ViewController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 5/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func SshowMenuslider(_ sender: AnyObject) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "MenuSlider")
        self.present(view!, animated: true, completion: nil)
    }
}
