//
//  ContrasenaGoogleViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 10/03/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ContrasenaGoogleViewController: UIViewController {

    @IBOutlet var bienvenidoLabel: UILabel!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var reescribeContraseñaTextfield: UITextField!
    
    // DATOS RECIBIDOS DE FACEBOOK
    var nombreCompletoGoogle: String!
    var idGoogle: String!
    var emailGoogle: String!
    var nombreGoogle: String!
    var apellidoGoogle: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bienvenidoLabel.text = "Bienvenido \(nombreCompletoGoogle)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func botonRegistrar(sender: AnyObject) {
        
        if contraseñaTextfield.text != reescribeContraseñaTextfield.text {
            mostraMSJ("Las contraseñas deben coincidir")
        } else {
            
            let contraseña = contraseñaTextfield.text! as String
            registrarConGoogle(nombreCompletoGoogle, idGoogle: idGoogle, emailGoogle: emailGoogle, contraseña: contraseña)
            
        }
        
        
        
    }
    
    func registrarConGoogle(var nombreCompleto: String, var idGoogle: String, var emailGoogle: String, var contraseña: String) {
        
        // Iniciar Loader
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Registrando usuario", andFooter: "Por favor espere...")
        
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        nombreCompleto = nombreCompleto.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        idGoogle = idGoogle.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        emailGoogle = emailGoogle.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/registraGoogle.php?n=" + nombreCompleto + "&c=" + emailGoogle + "&Gid=" + idGoogle + "&p=" + contraseña
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    
                }
                
                if let data = data {
                    
                    do {
                        
                        
                        if let errorResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            
                            let error = errorResult["error"] as! String
                            
                            print(error)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                let googleLog = GIDSignIn.sharedInstance()
                                googleLog.signOut()
                                
                                let alerta = UIAlertController(title: "Aprende y Crece", message: "Ya existe una cuenta registrada con ese correo", preferredStyle: UIAlertControllerStyle.Alert)
                                alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                    
                                    self.performSegueWithIdentifier("inicioALogin2", sender: self)
                                    
                                }))
                                
                                self.presentViewController(alerta, animated: true, completion: nil)
                                
                                //self.mostraMSJ("Ya existe una cuenta registrada con ese correo")
                                
                            })
                            
                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            //print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                let Gid = json["Gid"] as! NSDecimalNumber
                                let idUsuario = json["id"] as! Int
                                let nombreCompleto = json["nombre"] as! String
                                let token = json["token"] as! NSString
                                
                                print(correo)
                                print(Gid)
                                print(String(idUsuario))
                                print(nombreCompleto)
                                print(token)
                                
                                
                                let fullName = nombreCompleto
                                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                                
                                let nombre = fullNameArr[0]
                                let apellido = fullNameArr[1]
                                
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
                                NSUserDefaults.standardUserDefaults().setObject(Gid, forKey: "Gid")
                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                                NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
                                NSUserDefaults.standardUserDefaults().setObject(correo, forKey: "correo")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("inicio2", sender: self)
                                
                            })
                            
                            
                        }
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                    
                }
            })
            
            task.resume()
            
        }
    }
    
    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Aprende y Crece", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }

}
