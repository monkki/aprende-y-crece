//
//  NuevoIngresoViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 12/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import XLActionController

class NuevoIngresoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, FSCalendarDataSource, FSCalendarDelegate {

    // IBOutlets
    @IBOutlet var motivoTextfield: UITextField!
    @IBOutlet var montoTextview: UITextView!
    @IBOutlet var botonAyer: UIButton!
    @IBOutlet var botonHoy: UIButton!
    @IBOutlet var botonCalendario: UIButton!
    @IBOutlet var descripcionTextview: UITextView!
    @IBOutlet var botonRepetirGasto: UIButton!
    @IBOutlet var repetirGastoLabel: UILabel!
    @IBOutlet var botonGuardar: UIButton!
    
    private weak var calendar: FSCalendar!
    
    // Fecha
    var fecha: String!
    var motivo = "Comida"
    var repetirGasto = "Nunca"
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    
    // Vista Blur Calendario
    var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textview Descripcion
        descripcionTextview.delegate = self
        descripcionTextview.text = "Descripción..."
        descripcionTextview.textColor = UIColor.lightGrayColor()

        // TEXTFIELD
        motivoTextfield.addTarget(self, action: "motivoTextfieldAccion:", forControlEvents: UIControlEvents.TouchDown)
        
        var shortDate: String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(NSDate())
        }
        
        
        fecha = shortDate
        print(fecha)
        
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

  //  MARK: - Accion BOTONES
    
    
  // Motivo Textfield seleccionado
    func motivoTextfieldAccion(textField: UITextField) {
       
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Comida", style: .Default, handler: { action in
            
            self.motivoTextfield.text = "Comida"
            self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Compras", style: .Default, handler: { action in
            
            self.motivoTextfield.text = "Compras"
            self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Casa", style: .Default, handler: { action in
            
            self.motivoTextfield.text = "Casa"
            self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Otro", style: .Default, handler: { action in
            
            self.motivoTextfield.text = "Otro"
            self.motivo = self.motivoTextfield.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func accionBotonRepetirGasto(sender: AnyObject) {
        
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("Si", style: .Default, handler: { action in
            
            self.repetirGastoLabel.text = "Si"
            self.repetirGasto = self.repetirGastoLabel.text!
            
        }))
        actionController.addAction(Action("No", style: .Default, handler: { action in
            
            self.repetirGastoLabel.text = "No"
            self.repetirGasto = self.repetirGastoLabel.text!
            
        }))
        actionController.addAction(Action("Nunca", style: .Default, handler: { action in
            
            self.repetirGastoLabel.text = "Nunca"
            self.repetirGasto = self.repetirGastoLabel.text!
            
        }))
        actionController.addAction(Action("Siempre", style: .Default, handler: { action in
            
            self.repetirGastoLabel.text = "Siempre"
            self.repetirGasto = self.repetirGastoLabel.text!
            
        }))
        actionController.addAction(Action("Cancelar", style: .Cancel, handler: nil))
        
        presentViewController(actionController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func accionBotonAyer(sender: AnyObject) {
    }
    
    
    @IBAction func accionBotonHoy(sender: AnyObject) {
    }
    
    
    @IBAction func accionBotonCalendario(sender: AnyObject) {
        
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.center = blurView.center
        calendar.dataSource = self
        calendar.delegate = self
        blurView.addSubview(calendar)
        self.calendar = calendar


        
    }
    
    @IBAction func accionBotonGuardar(sender: AnyObject) {
        
        if montoTextview.text == "" {
            
            mostraMSJ("Por favor capture un monto")
            
        } else if motivoTextfield.text == "" {
            
            mostraMSJ("Por favor capture un motivo")
            
        } else if descripcionTextview.text == "" {
            
            mostraMSJ("Por favor capture una descripción")
        
        } else {
         
            insertarIngreso()
            
        }
        
    }
    

    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
    
        calendar.hidden = true
        blurView.hidden = true
        
        var shortDate: String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(date)
        }
        
        print(shortDate)
        fecha = shortDate
        
    }
    
    func minimumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        
        let date = NSDate()
        let calendario = NSCalendar.currentCalendar()
        let components = calendario.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return calendar.dateWithYear(year, month: month, day: day - 15)
    }
    
    
    

    
    

    //  MARK: - funcion insertar en tabla
    
    func insertarIngreso() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Guardando Ingreso", andFooter: "Por favor espere...")
        }
        
        var ingreso = montoTextview.text
        var descripcion = descripcionTextview.text
        
        //URL PARA INSERTAR INGRESOS
        // http://intercubo.com/aprendeycrece/api/ingreso.php?idUsuario=1234&ingreso=250&motivo=paragastos&fecha=24Marzo&descripcion=prueba&repetir=si
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        
        ingreso = ingreso.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        motivo = motivo.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        fecha = fecha.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        descripcion = descripcion.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        repetirGasto = repetirGasto.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let id = String(idUsuario)
        
        let urlString = "http://intercubo.com/aprendeycrece/api/insertarMontos.php?idUsuario=" + id + "&monto=" + ingreso + "&motivo=" + motivo + "&fecha=" + fecha + "&descripcion=" + descripcion + "&repetir=" + repetirGasto + "&tipo=i"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray

                        if jsonResponse.count > 0 {
                            
                            print(jsonResponse)
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                                let alertView = SCLAlertView()
                                alertView.showCloseButton = true
                                
                                alertView.showSuccess("Aprende y Crece", subTitle: "Se ha guardado su ingreso exitosamente")
                                
                                self.motivoTextfield.text = ""
                                self.montoTextview.text = ""
                                self.descripcionTextview.text = ""

                            })
                            
                            
                            
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                                let alertView = SCLAlertView()
                                alertView.showCloseButton = true
                                
                                alertView.showError("Aprende y Crece", subTitle: "Ha habido un problema al guardar su ingreso, porfavor intente nuevamente mas tarde")
                            })
                            
                        }
                        
                    } catch {
                        
                    }
                    
                    
                } else {
                    
                    print("No se pudo obtener data")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        JHProgressHUD.sharedHUD.hide()
                        let alertView = SCLAlertView()
                        alertView.showCloseButton = true
                        
                        alertView.showError("Aprende y Crece", subTitle: "Ha habido un problema al guardar su ingreso, porfavor intente nuevamente mas tarde")
                    })
                    
                }
                
            })
            task.resume()
            
            
        } else {
            
            print("No se pudo formar la URL")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                JHProgressHUD.sharedHUD.hide()
                let alertView = SCLAlertView()
                alertView.showCloseButton = true
                
                alertView.showError("Aprende y Crece", subTitle: "Ha habido un problema al guardar su ingreso, porfavor intente nuevamente mas tarde")
            })
            
        }
        
        
    }
    
    func mostraMSJ(msj: String){
        
        let alerta = UIAlertController(title: "Aprende y Crece", message: msj, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }

    
    // Metodos del Textview Descripcion
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Descripción..."
            textView.textColor = UIColor.lightGrayColor()
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
