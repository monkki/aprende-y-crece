//
//  ReportaErrorViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 16/03/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import MessageUI

class ReportaErrorViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var reportaTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func compartirEnEmail(sender: AnyObject) {
        
        if reportaTextView.text == "" {
            
            self.mostraMSJ("Porfavor ponga informacion sobre su error")
            
        } else {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["rgutierrezgonzalez@hotmail.com"])
        mailComposerVC.setSubject("App aprende y crece")
        mailComposerVC.setMessageBody(self.reportaTextView.text, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Error", message: "No se pudo enviar su email, intente nuevamente mas tarde", preferredStyle: UIAlertControllerStyle.Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("Email enviado correctamente")
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Aprende y Crece", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
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
