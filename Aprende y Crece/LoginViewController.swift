//
//  LoginViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 17/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    
    // TEXTFIELDS REGISTRAR
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!

    
    // DATOS RECIBIDOS DE FACEBOOK
    var nombreCompletoFacebook: String!
    var idFacebook: String!
    var emailFacebook: String!
    var nombreFacebook: String!
    var apellidoFacebook: String!
    var imagenFacebook: UIImage!
    
    // VARIABLES PARA LOGIN
    var email = ""
    var contraseña = ""
    let tokenRecibido = ""
    
    // ENLACE PARA REGISTRAR http://intercubo.com/aprendeycrece/api/registra.php?n=Roberto&c=r@hotmail.com&p=swamphell&fecha=24Marzo1982
    
    
    // ENLACE PARA LOGIN http://intercubo.com/aprendeycrece/api/login.php?c=rgutierrezgonzalez@hotmail.com&p=swamphell
    
    
    // ENLACE PARA LOGIN Google http://intercubo.com/aprendeycrece/api/loginRedes.php?c=robertogutierrezgonzalez1982@gmail.com&Gid=115277863506593734852
    
    // ENLACE PARA LOGIN CON Facebook http://intercubo.com/aprendeycrece/api/loginRedes.php?c=monkki@hotmail.com&fbid=10153929699184948
    
    
    
    // BOTONES DE LOGIN
    @IBOutlet var botonLoginFacebook: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        contraseñaTextfield.delegate = self
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentarWalktrough()
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            
            
        } else {
            
            botonLoginFacebook.readPermissions = ["public_profile", "email", "user_friends"]
            botonLoginFacebook.delegate = self
            
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if let nombre = NSUserDefaults.standardUserDefaults().objectForKey("nombre") as? String {
            
            if NSUserDefaults.standardUserDefaults().boolForKey("MetaInicialGuardada") == true {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("inicioSegue", sender: self)
                })
                
            } 
            
            print("Bienvenido " + nombre)
            
        } else {
            
        }

        
    }
    
    func presentarWalktrough() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough == false {
            if let pageViewController =
            storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as?
            PageViewController {
            self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // METODOS TEXTFIELD
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    
    
    // BOTON LOGIN MANUAL
    @IBAction func botonLoginManual(sender: AnyObject) {
        
        email = emailTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        contraseña = contraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        if (email == "" || contraseña == ""){
            
            mostraMSJ("Favor de completar los datos!")
            
            
        } else if(!isValidEmail(email)) {
            
            mostraMSJ("Favor de escribir un correo válido!")
            
        } else if(contraseña.characters.count < 7) {
            
            mostraMSJ("Favor de escribir una contraseña con más de 7 dígitos!")
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Logeando usuario", andFooter: "Por favor espere...")
            })
            
            loginUsuario()
            //print("Nickname es: \(nickname), nombre es \(nombre), fecha es \(fecha), email es \(email), contraseña es \(contraseña), reescribe contraseña es \(reescribeContraseña)")
            
        }
        
    }
    
    // FUNCION PARA LOGEAR USUARIO MANUALMENTE
    
    func loginUsuario() {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/login.php?c=" + email + "&p=" + contraseña
        
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
                                self.mostraMSJ("Correo o contraseña incorrectos")
                                
                            })
                            
                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                if let fbid = json["fbid"] as? Int {
                                    print(fbid)
                                    NSUserDefaults.standardUserDefaults().setObject(fbid, forKey: "fbid")
                                }
                                let idUsuario = json["id"] as! Int
                                let nombreCompleto = json["nombre"] as! String
                                let token = json["token"] as! NSString
                                
                                let fullName = nombreCompleto
                                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                                
                                let nombre = fullNameArr[0]
                                let apellido = fullNameArr[1]

                                
                                print(correo)
                                print(String(idUsuario))
                                print(nombre)
                                print(token)
                                
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                                NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
                                NSUserDefaults.standardUserDefaults().setObject(correo, forKey: "correo")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("inicioSegue", sender: self)
                                
                            })
                            
                            
                        }
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Iniciar Loader
                        JHProgressHUD.sharedHUD.hide()
                    })
                    print("Hubo un problema con la URL")
                    
                }
                
            })
            task.resume()
            
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.hide()
            })
            print("Hubo un problema con la URL")
            
        }
        
        
    }

    

    
    // METODOS DE FACEBOOK
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
            
        } else if result.isCancelled {
            // Handle cancellations
            
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
    
                
            }
            
            self.returnUserData()
            
        }
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Usuario ha salido")
    }
    
    
    func returnUserData() {
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Logeando usuario", andFooter: "Por favor espere...")
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture.type(large), first_name, last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
                
            } else {
                
                //Obtener nombre de facebook
                print("Usuario es: \(result)")
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    self.nombreCompletoFacebook = userName as String
                    print("Nombre de usuario es : \(userName)")
                }
                
                //Obtener id de facebook
                if let id : NSString = result.valueForKey("id") as? NSString {
                    self.idFacebook = id as String
                    NSUserDefaults.standardUserDefaults().setObject(self.idFacebook, forKey: "idFacebookDefaults")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("id de usuario es: \(id)")
                    
                }
                
                //Obtener email de facebook
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    self.emailFacebook = userEmail as String
                    print("Email de usuario es: \(userEmail)")
                    NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "correo")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }
                
                //Obtener email de facebook
                if let nombre : NSString = result.valueForKey("first_name") as? NSString {
                    self.nombreFacebook = nombre as String
                    print("nombre es: \(nombre)")
                    NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }
                
                //Obtener email de facebook
                if let apellido : NSString = result.valueForKey("last_name") as? NSString {
                    self.apellidoFacebook = apellido as String
                    print("Apellido es: \(apellido)")
                    NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }
                
                //Obtener imagen de facebook
                if let picture : NSDictionary = result.valueForKey("picture") as? NSDictionary {
                    if let data = picture["data"] as? NSDictionary {
                        if let imagen = data["url"] as? String {
                            if let url  = NSURL(string: imagen),
                                data = NSData(contentsOfURL: url){
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.imagenFacebook = UIImage(data: data)
                                    })
                            }
                        }
                    }
                    
                }
                
            }
            
            self.returnUserProfileImage(self.idFacebook)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loginConFacebook(self.emailFacebook, idFacebook: self.idFacebook)
            })
        })
    }
    
    
    // accessToken is your Facebook id
    func returnUserProfileImage(accessToken: String) {
        let userID = accessToken as String
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let imagenGrandeFace = UIImage(data: data)
                print("La imagen grande de facebbok es \(imagenGrandeFace)")
                
                // Guardar imagen de perfil
                var documentsDirectory:String?
                
                var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                
                if paths.count > 0 {
                    
                    documentsDirectory = paths[0] as? String
                    
                    let savePath = documentsDirectory! + "/imagenPerfil.jpg"
                    
                    NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                    
                    
                }
                
            })
        }
        
    }
    
    func hacerSegue() {
        self.performSegueWithIdentifier("inicioSegue", sender: self)
    }
    
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
        
    }

    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Aprende y Crece", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
  
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contrasenaSegue3" {
            
            let destinoVC = segue.destinationViewController as! ContrasenaFaceViewController
            destinoVC.nombreCompletoFacebook = nombreCompletoFacebook
            destinoVC.emailFacebook = emailFacebook
            destinoVC.idFacebook = idFacebook
            destinoVC.nombreFacebook = nombreFacebook
            destinoVC.apellidoFacebook = apellidoFacebook
            
        }
        
        
    }
    
    // MARK: - Login Facebook
    
    // FUNCION PARA LOGEAR USUARIO FACEBOOK
    
    func loginConFacebook(var emailFacebookM: String, var idFacebook: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        idFacebook = idFacebook.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        emailFacebookM = emailFacebookM.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/login.php?c=" + emailFacebookM + "&fbid=" + idFacebook
        
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
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                                self.performSegueWithIdentifier("contrasenaSegue3", sender: self)
                            })
                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                if let fbid = json["fbid"] as? Int {
                                    print(fbid)
                                    NSUserDefaults.standardUserDefaults().setObject(fbid, forKey: "fbid")
                                }
                                let idUsuario = json["id"] as! Int
                                let nombreCompleto = json["nombre"] as! String
                                let token = json["token"] as! NSString
                                
                                let fullName = nombreCompleto
                                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                                
                                let nombre = fullNameArr[0]
                                let apellido = fullNameArr[1]
                                
                                print(correo)
                                print(String(idUsuario))
                                print(nombre)
                                print(token)
                                
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                                NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
                                NSUserDefaults.standardUserDefaults().setObject(correo, forKey: "correo")
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "MetaInicialGuardada")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("inicioSegue", sender: self)
                                
                            })
                            
                            
                        }
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                    
                }
            })
            
            task.resume()
            
        }
    }



}
