//
//  PageContentViewController.swift
//  Walktrough Demo
//
//  Created by Roberto Gutierrez on 17/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    @IBOutlet var registrateBoton: UIButton!
    @IBOutlet var ingresaBoton: UIButton!
    
    
    var index : Int = 0
    var heading : String = ""
    var imageFile : String = ""
    var subHeading : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
           self.registrateBoton.setX(10.0)
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            self.registrateBoton.setX(10.0)
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            self.registrateBoton.setX(10.0)
            
        } else if (self.view.frame.size.width > 414){
            //iPad
            self.registrateBoton.setX(10.0)
            
        }
        
//        registrateBoton.enabled = (index == 2) ? true : false
//        ingresaBoton.enabled = (index == 2) ? true :  false

        pageControl.currentPage = index
        
        
        // subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.registrateBoton.setX(10.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        

    }
    
    // Funcion botones
    
    @IBAction func registrateBotonPresionado(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ingresaBotonPresionado(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/**
 Extension UIView
 by DaRk-_-D0G
 */
extension UIView {
    /**
     Set x Position
     
     :param: x CGFloat
     by DaRk-_-D0G
     */
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position
     
     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width
     
     :param: width CGFloat
     by DaRk-_-D0G
     */
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height
     
     :param: height CGFloat
     by DaRk-_-D0G
     */
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}
