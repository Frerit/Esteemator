//
//  HomePageViewController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 5/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   
    
    var pageViewController: UIPageViewController!
    let pages = ["FirstPageVC","SecondPageVC","ThrirdPageVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc  = storyboard?.instantiateViewController(withIdentifier: "PageviewControllers") {
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            self.pageViewController.dataSource = self
            self.pageViewController.delegate = self
            
            pageViewController.setViewControllers([self.viewcontrollerAtOIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
            pageViewController.didMove(toParentViewController: self)
        }
    }

    func viewcontrollerAtOIndex(index: Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        return vc
    }
    
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }

    
    
}
