//
//  ViewController.swift
//  Esteemator-Pro
//
//  Created by Julian Perez on 5/04/17.
//  Copyright © 2017 strategee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {

    var pageController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImage: NSArray!
    
    @IBOutlet weak var butonRegister: UIButton!
    @IBOutlet weak var butonLogin: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "Primero","Second","Tercero")
        self.pageImage = NSArray(objects: "01","02","03")
        
        self.pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        self.pageController.dataSource = self
        
        let starVC = self.viewControllerAtIndex(index: 0) as  ContentPageViewController
        let viewController = NSArray(object: starVC)
        
        self.pageController.setViewControllers(viewController as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParentViewController: self)
        
        self.butonLogin.layer.cornerRadius = 3
        self.butonRegister.layer.cornerRadius = 3
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> ContentPageViewController {
        if ((self.pageTitles.count == 0 ) || (index >= self.pageTitles.count)) {
            return ContentPageViewController()
        }
        
        let vc: ContentPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentPageViewController
        
        vc.imagefile = self.pageImage[index] as! String
        vc.titleIndex = self.pageTitles[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentPageViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) { return nil }
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentPageViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound) {   return nil  }
        
        index += 1
        if ( index == self.pageTitles.count) {  return nil }
        
        return self.viewControllerAtIndex(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
}

