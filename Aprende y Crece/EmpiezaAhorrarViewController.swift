//
//  EmpiezaAhorrarViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 26/05/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import XLActionController

class EmpiezaAhorrarViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var ingresoTextView: UITextView!
    @IBOutlet var tipoDeIngresoLabel: UILabel!
    
    //Botones
    @IBOutlet var viviendaBoton: UIButton!
    @IBOutlet var serviciosBoton: UIButton!
    @IBOutlet var telefonoBoton: UIButton!
    @IBOutlet var entretenimientoBoton: UIButton!
    
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int

    override func viewDidLoad() {
        super.viewDidLoad()

        ingresoTextView.delegate = self
        ingresoTextView.text = "Ingreso"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PerfilViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Metodos del Textview Descripcion
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = nil
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView == ingresoTextView {
            if textView.text.isEmpty {
                textView.text = "Ingreso"
            }
        }
        
    }
    
    // MARK: - Acciones
    
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
    
    
    @IBAction func viviendaBotonPressed(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        let txt = alertView.addTextField("Gastos de vivienda")
        alertView.addButton("Guardar") {
            
            print("Text value: \(txt.text)")
            
            if txt.text == "" {
                
                let alerta = UIAlertController(title: "Aprende y crece", message: "Por favor ingrese su gasto de vivienda" , preferredStyle: .Alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alerta, animated: true, completion: nil)
                
            } else {
                
                self.actualizarPerfilyBoton("gastosVivienda", valor: txt.text!, botonFuncion: self.viviendaBoton)
        
            }
            
        }
        
        alertView.showEdit("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de vivienda")

        
    }
    
    
    
    @IBAction func serviciosBotonPressed(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        let txt = alertView.addTextField("Gastos de servicios")
        alertView.addButton("Guardar") {
            
            print("Text value: \(txt.text)")
            
            if txt.text == "" {
                
                let alerta = UIAlertController(title: "Aprende y crece", message: "Por favor ingrese su gasto de servicios" , preferredStyle: .Alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alerta, animated: true, completion: nil)
                
            } else {
                
                self.actualizarPerfilyBoton("gastosServicios", valor: txt.text!, botonFuncion: self.serviciosBoton)
                
            }
            
        }
        
        alertView.showEdit("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de servicios")
        
    }
    
    
    
    @IBAction func telefonoBotonPressed(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        let txt = alertView.addTextField("Gastos de telefono")
        alertView.addButton("Guardar") {
            
            print("Text value: \(txt.text)")
            
            if txt.text == "" {
                
                let alerta = UIAlertController(title: "Aprende y crece", message: "Por favor ingrese su gasto de telefono" , preferredStyle: .Alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alerta, animated: true, completion: nil)
                
            } else {
                
                 self.actualizarPerfilyBoton("gastosTelefono", valor: txt.text!, botonFuncion: self.telefonoBoton)
                
            }
            
        }
        
        alertView.showEdit("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de telefono")
        
    }
    
    
    @IBAction func entretenimientoBotonPressed(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        let txt = alertView.addTextField("Gastos de entretenimiento")
        alertView.addButton("Guardar") {
            
            print("Text value: \(txt.text)")
            
            if txt.text == "" {
                
                let alerta = UIAlertController(title: "Aprende y crece", message: "Por favor ingrese su gasto de entretenimiento" , preferredStyle: .Alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alerta, animated: true, completion: nil)
                
            } else {
             
                self.actualizarPerfilyBoton("gastosEntretenimiento", valor: txt.text!, botonFuncion: self.entretenimientoBoton)
                
                
            }
            
        }
        
        alertView.showEdit("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de entretenimiento")
        
        
    }
    
    
    @IBAction func botonGuardar(sender: AnyObject) {
        
        if viviendaBoton.imageView?.image == UIImage(named: "botonMas") {
            
            let alertView = SCLAlertView()
            alertView.showError("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de vivienda")
            
        } else if serviciosBoton.imageView?.image == UIImage(named: "botonMas") {
            
            let alertView = SCLAlertView()
            alertView.showError("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de servicios")
            
        }  else if entretenimientoBoton.imageView?.image == UIImage(named: "botonMas") {
            
            let alertView = SCLAlertView()
            alertView.showError("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de entretenimiento")
            
        } else if telefonoBoton.imageView?.image == UIImage(named: "botonMas") {
            
            let alertView = SCLAlertView()
            alertView.showError("Aprende y Crece", subTitle: "Porfavor agregue sus gastos de telefono")
            
        } else if ingresoTextView.text == "" || ingresoTextView.text == "Ingreso"  {
            
            let alertView = SCLAlertView()
            alertView.showError("Aprende y Crece", subTitle: "Porfavor agregue sus ingresos")
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Guardando sus datos", andFooter: "Por favor espere...")
            })
            
            self.actualizarIngresos("ingreso", valor: self.ingresoTextView.text!)
            
            
        }
        
    
    }
    
    
    
    
    func actualizarPerfil(campo:String, valor: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let campo = campo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let valor = valor.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
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

    
    func actualizarPerfilyBoton(campo:String, valor: String, botonFuncion: UIButton) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let campo = campo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let valor = valor.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
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
                        
                        if jsonResponse.count > 0 {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                botonFuncion.setImage(UIImage(named: "palomaBoton"), forState: UIControlState.Normal)
                                
                            })
                            
                        }
                        
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
    
    
    func actualizarIngresos(campo:String, valor: String) {
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let campo = campo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        let valor = valor.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
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
                        
                        if jsonResponse.count > 0 {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                                JHProgressHUD.sharedHUD.hide()
                                self.performSegueWithIdentifier("miMeta", sender: self)
                                
                                
                            })
                            
                        }
                        
                        print(jsonResponse)
                        
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    print("Hubo un problema al obtener data")
                    JHProgressHUD.sharedHUD.hide()
                }
                
            })
            task.resume()
            
        } else {
            
            print("Hubo un problema al obtener la url")
             JHProgressHUD.sharedHUD.hide()
            
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
