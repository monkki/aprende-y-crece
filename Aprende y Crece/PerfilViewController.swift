//
//  PerfilViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 19/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import XLActionController

class PerfilViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // IBOutlets
    @IBOutlet var fotoUsuario: UIImageView!
    @IBOutlet var nombreTextView: UITextView!
    @IBOutlet var apellidosTextView: UITextView!
    @IBOutlet var emailTextView: UITextView!
    @IBOutlet var edadLabel: UILabel!
    @IBOutlet var generoLabel: UILabel!
    @IBOutlet var ubicacionLabel: UILabel!
    @IBOutlet var profesionLabel: UILabel!
    @IBOutlet var tipoDeIngresoLabel: UILabel!
    @IBOutlet var ingresoLabel: UILabel!
    
    var nombre = NSUserDefaults.standardUserDefaults().objectForKey("nombre") as! String
    var correo = NSUserDefaults.standardUserDefaults().objectForKey("correo") as! String
    
    // Variables para actualizar perfil
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    
    
    // Enlace para actualizar perfil http://intercubo.com/aprendeycrece/api/actualizarPerfil.php?nombre=Ruperto&correo=roberto@somospulso.com&edad=33&genero=masculino&ubicacion=Sonora&profesion=Desarrollador&tipoIngreso=fijo&ingreso=9000&idUsuario=1234

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextViews nombre, apellidos y email
        nombreTextView.delegate = self
        nombreTextView.text = "Nombre(s)"
        
        apellidosTextView.delegate = self
        apellidosTextView.text = "Apellido(s)"
        
        emailTextView.delegate = self
        emailTextView.text = "e-mail"
    

        // Foto de perfil circular
        self.fotoUsuario.layer.borderWidth = 2.0
        self.fotoUsuario.layer.borderColor = UIColor.whiteColor().CGColor
        self.fotoUsuario.layer.cornerRadius = self.fotoUsuario.frame.height/2
        self.fotoUsuario.layer.masksToBounds = true
        
        //Pintar imagen de perfil
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            nombreTextView.text = nombre
            
            if let apellido = NSUserDefaults.standardUserDefaults().objectForKey("apellido") as? String {
                apellidosTextView.text = apellido
            } else {
                apellidosTextView.text = ""
            }
            
            emailTextView.text = correo
            
            var documentsDirectory:String?
            
            var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            if paths.count > 0 {
                
                documentsDirectory = paths[0] as? String
                
                if let savePath: String = documentsDirectory! + "/imagenPerfil.jpg" {
                    
                    self.fotoUsuario.image = UIImage(named: savePath)
                    
                    // print(savePath)
                    
                }
                
            }
            
        } else {
            
            
            let nombre = NSUserDefaults.standardUserDefaults().objectForKey("nombre") as! String
            nombreTextView.text = nombre
            
            
            if let apellido = NSUserDefaults.standardUserDefaults().objectForKey("apellido") as? String {
                apellidosTextView.text = apellido
            } else {
                apellidosTextView.text = ""
            }
            
            if let correo = NSUserDefaults.standardUserDefaults().objectForKey("correo") as? String {
                emailTextView.text = correo
            } else {
                emailTextView.text = ""
            }
            
            self.fotoUsuario.image = UIImage(named: "fotoPlaceholder")
            
            
//            
//            var documentsDirectory:String?
//            
//            var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//            
//            if paths.count > 0 {
//                
//                documentsDirectory = paths[0] as? String
//                
//                if let savePath: String = documentsDirectory! + "/imagenPerfil.jpg" {
//                    
//                    self.fotoUsuario.image = UIImage(named: savePath)
//                    
//                    // print(savePath)
//                    
//                }
//                
//            } else {
//                
//                self.fotoUsuario.image = UIImage(named: "fotoPlaceholder")
//                
//            }

            
            
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        obtenerDatosPerfil()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutBoton(sender: AnyObject) {
        
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("tokenServer")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("fbid")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("idUsuario")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("nombre")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("correo")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("apellido")
        

        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let googleLog = GIDSignIn.sharedInstance()
        googleLog.signOut()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        })
    }
    
    
    
    // Metodos del Textview Descripcion
    
    func textViewDidBeginEditing(textView: UITextView) {
    
        textView.text = nil
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == nombreTextView {
            if textView.text.isEmpty {
                textView.text = "Nombre(s)"
            }
        } else if textView == apellidosTextView {
            if textView.text.isEmpty {
                textView.text = "Apellido(s)"
            }
        } else if textView == emailTextView {
            if textView.text.isEmpty {
                textView.text = "e-mail"
            }
        }
        
    }
    

    // Funcionalidad Botones
    
    @IBAction func edadBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("de 18 a 25 años", style: .Default, handler: { action in
            
            self.edadLabel.text = "de 18 a 25 años"
            self.actualizarPerfil("edad", valor: "de 18 a 25 años")
           // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("de 26 a 30 años", style: .Default, handler: { action in
            
            self.edadLabel.text = "de 26 a 30 años"
            self.actualizarPerfil("edad", valor: "de 26 a 30 años")
           // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("de 31 a 40 años", style: .Default, handler: { action in
            
            self.edadLabel.text = "de 31 a 40 años"
            self.actualizarPerfil("edad", valor: "de 31 a 40 años")
           // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("de 41 a 50 años", style: .Default, handler: { action in
            
            self.edadLabel.text = "de 41 a 50 años"
            self.actualizarPerfil("edad", valor: "de 41 a 50 años")
           // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("de 50 o mas años", style: .Default, handler: { action in
            
            self.edadLabel.text = "de 50 o mas años"
            self.actualizarPerfil("edad", valor: "de 50 o mas años")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    @IBAction func generoBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Masculino", style: .Default, handler: { action in
            
            self.generoLabel.text = "Masculino"
            self.actualizarPerfil("genero", valor: "Masculino")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Femenino", style: .Default, handler: { action in
            
            self.generoLabel.text = "Femenino"
            self.actualizarPerfil("genero", valor: "Femenino")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    @IBAction func ubicacionBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Ubicación", style: .Default, handler: { action in
            
            self.ubicacionLabel.text = "Ubicación"
            self.actualizarPerfil("ubicacion", valor: "Ubicación")
            
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    @IBAction func profesionBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Comerciante", style: .Default, handler: { action in
            
            self.profesionLabel.text = "Comerciante"
            self.actualizarPerfil("profesion", valor: "Comerciante")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Profesionista", style: .Default, handler: { action in
            
            self.profesionLabel.text = "Profesionista"
            self.actualizarPerfil("profesion", valor: "Profesionista")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Empleado", style: .Default, handler: { action in
            
            self.profesionLabel.text = "Empleado"
            self.actualizarPerfil("profesion", valor: "Empleado")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Ama de casa", style: .Default, handler: { action in
            
            self.profesionLabel.text = "Ama de casa"
            self.actualizarPerfil("profesion", valor: "Ama de casa")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Otro", style: .Default, handler: { action in
            
            self.profesionLabel.text = "Otro"
            self.actualizarPerfil("profesion", valor: "Otro")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tipoDeIngresoBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Variable", style: .Default, handler: { action in
            
            self.tipoDeIngresoLabel.text = "Variable"
            self.actualizarPerfil("tipoIngreso", valor: "Variable")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Fijo", style: .Default, handler: { action in
            
            self.tipoDeIngresoLabel.text = "Fijo"
            self.actualizarPerfil("tipoIngreso", valor: "Fijo")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Mixto", style: .Default, handler: { action in
            
            self.tipoDeIngresoLabel.text = "Mixto"
            self.actualizarPerfil("tipoIngreso", valor: "Mixto")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func ingresoBotonPressed(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("0 - 5000", style: .Default, handler: { action in
            
            self.ingresoLabel.text = "0 - 5000"
            self.actualizarPerfil("ingreso", valor: "0 - 5000")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("5001 - 10,000", style: .Default, handler: { action in
            
            self.ingresoLabel.text = "5001 - 10,000"
            self.actualizarPerfil("ingreso", valor: "5001 - 10,000")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("10,001 - 20,000", style: .Default, handler: { action in
            
            self.ingresoLabel.text = "10,001 - 20,000"
            self.actualizarPerfil("ingreso", valor: "10,001 - 20,000")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("20,001 - 30,000", style: .Default, handler: { action in
            
            self.ingresoLabel.text = "20,001 - 30,000"
            self.actualizarPerfil("ingreso", valor: "20,001 - 30,000")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("30,001 o más", style: .Default, handler: { action in
            
            self.ingresoLabel.text = "30,001 o más"
            self.actualizarPerfil("ingreso", valor: "30,001 o más")
            // self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
    }
    
    
    
    // Funcion para borrar imagen de perfil
    
    func removeOldFileIfExist() {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0]
            let fileName = "imagenPerfil"
            let filePath = NSString(format:"%@/%@.jpg", dirPath, fileName) as String
            if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(filePath)
                    print("old image has been removed")
                } catch {
                    print("an error during a removing")
                }
            }
        }
    }

    
    func actualizarPerfil(var campo:String, var valor: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
    
        campo = campo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        valor = valor.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/actualizarVariable.php?idUsuario=" + String(idUsuario) + "&campo=" + campo + "&valor=" + valor
    
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        print(jsonResponse)
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    print("Hubo un problema al obtener data")
                }
                
            })
            task.resume()
            
        } else {
            
            print("Hubo un problema al obtener la url")
            
        }
        
    }
    
    func obtenerDatosPerfil() {
        
        let urlString = "http://intercubo.com/aprendeycrece/api/obtenerDatosPerfil.php?idUsuario=" + String(idUsuario)
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        if jsonResponse.count > 0 {
                            
                            for json in jsonResponse {
                                
                                let edad = json["edad"] as! String
                                let genero = json["genero"] as! String
                                let ubicacion = json["ubicacion"] as! String
                                let profesion = json["profesion"] as! String
                                let tipoIngreso = json["tipoIngreso"] as! String
                                let ingreso = json["ingreso"] as! String
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.edadLabel.text = edad
                                    self.generoLabel.text = genero
                                    self.ubicacionLabel.text = ubicacion
                                    self.profesionLabel.text = profesion
                                    self.tipoDeIngresoLabel.text = tipoIngreso
                                    self.ingresoLabel.text = ingreso
                                    
                                })
                                

                            }
                            
                            print(jsonResponse)
                            
                        }
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    print("Hubo un problema al obtener data")
                }
                
            })
            task.resume()
            
        } else {
            print("Hubo un problema al obtener la url")
        }
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




