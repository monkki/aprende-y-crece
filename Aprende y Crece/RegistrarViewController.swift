//
//  RegistrarViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 19/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class RegistrarViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    // DATOS RECIBIDOS DE FACEBOOK
    var nombreCompletoFacebook: String!
    var idFacebook: String!
    var emailFacebook: String!
    var nombreFacebook: String!
    var apellidoFacebook: String!
    var imagenFacebook: UIImage!
    
    // DATOS RECIBIDOS DE GOOGLE
    var nombreCompletoGoogle: String!
    var idGoogle: String!
    var emailGoogle: String!
    var nombreGoogle: String!
    var apellidoGoogle: String!
    
    
    // BOTONES DE LOGIN
    @IBOutlet var botonLoginFacebook: FBSDKLoginButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    // TEXTFIELDS REGISTRAR
    @IBOutlet var nombreTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var contraseñaTextfield: UITextField!
    @IBOutlet var reescribeContraseñaTextfield: UITextField!
    
    var nombre = ""
    var email = ""
    var contraseña = ""
    var reescribeContraseña = ""
    
    let tokenRecibido = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        nombreTextfield.delegate = self
        emailTextfield.delegate = self
        contraseñaTextfield.delegate = self
        reescribeContraseñaTextfield.delegate = self
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
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
                    self.performSegueWithIdentifier("inicioSegue2", sender: self)
                })
                
            }

            print("Bienvenido " + nombre)
            
        } else {
            
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
    
    
    // METODOS DE FACEBOOK
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            
            print(error.localizedDescription)
            
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
                    print("id de usuario es: \(id)")
                    
                }
                
                //Obtener email de facebook
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    self.emailFacebook = userEmail as String
                    print("Email de usuario es: \(userEmail)")
                    
                    
                }
                
                //Obtener email de facebook
                if let nombre : NSString = result.valueForKey("first_name") as? NSString {
                    self.nombreFacebook = nombre as String
                    print("nombre es: \(nombre)")
                    
                    
                }
                
                //Obtener email de facebook
                if let apellido : NSString = result.valueForKey("last_name") as? NSString {
                    self.apellidoFacebook = apellido as String
                    print("Apellido es: \(apellido)")
                    
                    
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("contrasenaSegue", sender: self)
            })
            
            // self.loginFacebook(self.idFacebook)
            // self.hacerSegue()
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
        self.performSegueWithIdentifier("inicioSegue2", sender: self)
    }
    
    /// METODOS DE SIGN IN GOOGLE
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if let err = error {
            print(err)
        }
        else {
            print(GIDSignIn.sharedInstance().currentUser.profile.imageURLWithDimension(150))
            
            let url = GIDSignIn.sharedInstance().currentUser.profile.imageURLWithDimension(150)
            
            // Obtener foto de Google
            
            let fotoGoogle = url
            
            if let data = NSData(contentsOfURL: fotoGoogle!) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let imagenGrandeGoogle = UIImage(data: data)
                    print("La imagen grande de google es es \(imagenGrandeGoogle)")
                    
                    
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
            
            
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            
            
            
            print("User id " + userId)
            print("Token id " + idToken)
            print("Nombre " + name)
            print("email " + email)
            
            let fullName = name
            let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
            
            let nombre = fullNameArr[0]
            let apellido = fullNameArr[1]
            
            // DATOS RECIBIDOS DE GOOGLE
            nombreCompletoGoogle = name
            idGoogle = userId
            emailGoogle = email
            nombreGoogle = nombre
            apellidoGoogle = apellido
            
            NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
            NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
            NSUserDefaults.standardUserDefaults().setObject(email, forKey: "correo")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("contrasenaSegue2", sender: self)
            })
            
            //performSegueWithIdentifier("inicioSegue2", sender: self)
            
            
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
        
    }
    
    // BOTON REGISTRAR
    
    @IBAction func RegistrarBoton(sender: AnyObject) {
        
        nombre = nombreTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        email = emailTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        contraseña = contraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        reescribeContraseña = reescribeContraseñaTextfield.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
        
        if( nombre == "" || email == "" || contraseña == "" || reescribeContraseña == ""){
            
            mostraMSJ("Favor de completar los datos!")
            
            
        } else if(contraseña != reescribeContraseña) {
            
            mostraMSJ("Las contraseñas deben de coincidir!")
            
        } else if(!isValidEmail(email)) {
            
            mostraMSJ("Favor de escribir un correo válido!")
            
        } else if(contraseña.characters.count < 7) {
            
            mostraMSJ("Favor de escribir una contraseña con más de 7 dígitos!")
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Registrando usuario", andFooter: "Por favor espere...")
            })
            registrarUsuario();
            
            //print("Nickname es: \(nickname), nombre es \(nombre), fecha es \(fecha), email es \(email), contraseña es \(contraseña), reescribe contraseña es \(reescribeContraseña)")
            
        }
        
        
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
    
    
    // FUNCION PARA REGISTRAR USUARIO
    
    func registrarUsuario() {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        nombre = nombre.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/registra.php?n=" + nombre + "&c=" + email + "&p=" + contraseña
        
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
                                self.mostraMSJ("Ya existe una cuenta registrada con ese correo")
                                
                            })
                            
                            
                            
                        } else {
                            
                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            //print(jsonResult)
                            
                            for json in jsonResult {
                                
                                let correo = json["correo"] as! String
                                let display = json["display"] as! String
                                let fbid = json["fbid"] as! String
                                let idUsuario = json["id"] as! Int
                                let nombreCompleto = json["nombre"] as! String
                                let token = json["token"] as! NSString
                                
                                print(correo)
                                print(display)
                                print(fbid)
                                print(String(idUsuario))
                                print(nombreCompleto)
                                print(token)
                                
                                let fullName = nombreCompleto
                                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                                
                                let nombre = fullNameArr[0]
                                let apellido = fullNameArr[1]
                                
                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
                                NSUserDefaults.standardUserDefaults().setObject(fbid, forKey: "fbid")
                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
                                NSUserDefaults.standardUserDefaults().setObject(apellido, forKey: "apellido")
                                NSUserDefaults.standardUserDefaults().setObject(correo, forKey: "correo")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Iniciar Loader
                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("inicioSegue2", sender: self)
                                
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contrasenaSegue" {
            
            let destinoVC = segue.destinationViewController as! ContrasenaFaceViewController
            destinoVC.nombreCompletoFacebook = nombreCompletoFacebook
            destinoVC.emailFacebook = emailFacebook
            destinoVC.idFacebook = idFacebook
            destinoVC.nombreFacebook = nombreFacebook
            destinoVC.apellidoFacebook = apellidoFacebook
            
        } else if segue.identifier == "contrasenaSegue2" {
            
            let destinoVC = segue.destinationViewController as! ContrasenaGoogleViewController
            destinoVC.nombreCompletoGoogle = nombreCompletoGoogle
            destinoVC.idGoogle = idGoogle
            destinoVC.emailGoogle = emailGoogle
            destinoVC.nombreGoogle = nombreGoogle
            destinoVC.apellidoGoogle = apellidoGoogle
            
            
        }
        
        
    }

    
//    // REGISTRAR CON FACEBOOK
//    
//    func registrarConFacebook(var nombreCompleto: String, var idFacebook: String, var emailFacebookM: String, var contraseña: String) {
//        
//        // Iniciar Loader
//        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Registrando usuario", andFooter: "Por favor espere...")
//        
//        
//        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
//        
//        nombreCompleto = nombreCompleto.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
//        idFacebook = idFacebook.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
//        emailFacebookM = emailFacebookM.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
//        contraseña = contraseña.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
//        
//        let urlString = "http://intercubo.com/aprendeycrece/api/registra.php?n=" + nombreCompleto + "&c=" + emailFacebookM + "&fbid=" + idFacebook + "&p=" + contraseña
//        
//        let url = NSURL(string: urlString)
//        
//        if let url = url {
//            
//            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
//                
//                if error != nil {
//                    
//                    print(error?.localizedDescription)
//                    
//                }
//                
//                if let data = data {
//                    
//                    do {
//                        
//                        
//                        if let errorResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//                            
//                            let error = errorResult["error"] as! String
//                            
//                            print(error)
//                            
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                // Iniciar Loader
//                                JHProgressHUD.sharedHUD.hide()
//                                let loginManager = FBSDKLoginManager()
//                                loginManager.logOut()
//                                
//                                let alerta = UIAlertController(title: "Adventure Hike", message: "Ya existe una cuenta registrada con ese correo", preferredStyle: UIAlertControllerStyle.Alert)
//                                alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//                                    
//                                    self.performSegueWithIdentifier("inicioALogin", sender: self)
//                                    
//                                }))
//                                
//                                self.presentViewController(alerta, animated: true, completion: nil)
//                                
//                                //self.mostraMSJ("Ya existe una cuenta registrada con ese correo")
//                                
//                            })
//                            
//                            
//                            
//                        } else {
//                            
//                            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
//                            
//                            //print(jsonResult)
//                            
//                            for json in jsonResult {
//                                
//                                let correo = json["correo"] as! String
//                                let display = json["display"] as! String
//                                let fbid = json["fbid"] as! Int
//                                let fechaNac = json["fecha_nac"] as! String
//                                let idUsuario = json["id"] as! Int
//                                let nickname = json["nickname"] as! String
//                                let nombre = json["nombre"] as! String
//                                let token = json["token"] as! NSString
//                                
//                                print(correo)
//                                print(display)
//                                print(fbid)
//                                print(fechaNac)
//                                print(String(idUsuario))
//                                print(nickname)
//                                print(nombre)
//                                print(token)
//                                
//                                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "tokenServer")
//                                NSUserDefaults.standardUserDefaults().setObject(fbid, forKey: "fbid")
//                                NSUserDefaults.standardUserDefaults().setObject(idUsuario, forKey: "idUsuario")
//                                NSUserDefaults.standardUserDefaults().setObject(nombre, forKey: "nombre")
//                                NSUserDefaults.standardUserDefaults().synchronize()
//                                
//                            }
//                            
//                            
//                            
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                // Iniciar Loader
//                                JHProgressHUD.sharedHUD.hide()
//                                self.performSegueWithIdentifier("inicio", sender: self)
//                                
//                            })
//                            
//                            
//                        }
//                        
//                        
//                    } catch {
//                        
//                        
//                    }
//                    
//                    
//                    
//                }
//            })
//            
//            task.resume()
//            
//        }
//    }
//    




}
