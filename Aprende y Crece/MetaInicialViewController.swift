//
//  MetaInicialViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 04/03/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class MetaInicialViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, FSCalendarDataSource, FSCalendarDelegate {

    // Web Service para insertar metas
    // http://intercubo.com/aprendeycrece/api/insertarMeta.php?idUsuario=1234&nombreMeta=Meta1&fechaInicio=2016-01-01&fechaTermino=2016-02-02&montoMeta=30000&montoMinimo=500
    
    // IBOutlets
    @IBOutlet var imagenSubirFoto: UIImageView!
    @IBOutlet var nombreMiMetaTextView: UITextView!
    @IBOutlet var cantidadAhorrarTextView: UITextView!
    @IBOutlet var fechaInicioLabel: UILabel!
    @IBOutlet var fechaTerminoLabel: UILabel!
    @IBOutlet var ahorroDeberaSerTextView: UITextView!
    @IBOutlet var frecuenciaAhorroLabel: UILabel!
    
    // Vista Blur Calendario
    var blurView: UIVisualEffectView!
    
    //Calendario
    private weak var calendario1 = FSCalendar()
    private weak var calendario2 = FSCalendar()
    
    // Distancia de dias
    var diferenciaDeDias = 0
    
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    
    // Fecha
    var fecha: String!
    var fechaInicio = NSDate()
    var fechaTermino = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextViews nombre, apellidos y email
        nombreMiMetaTextView.delegate = self
        nombreMiMetaTextView.text = "Nombre de Mi Meta"
        
        cantidadAhorrarTextView.delegate = self
        cantidadAhorrarTextView.text = ""
        
        ahorroDeberaSerTextView.delegate = self
        ahorroDeberaSerTextView.text = ""
        
        // Fechas TextViews
        fechaInicioLabel.text = ""
        fechaTerminoLabel.text = ""
        
        
        //Fecha
        var shortDate: String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(NSDate())
        }
        
        fecha = shortDate
        print(fecha)
        
        fechaInicioLabel.text = fecha
        
        
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Metodos de los Textview
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = nil
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == nombreMiMetaTextView {
            if textView.text.isEmpty {
                textView.text = "Nombre de Mi Meta"
            }
        } else if textView == cantidadAhorrarTextView {
            if textView.text.isEmpty {
                textView.text = ""
            }
        } else if textView == ahorroDeberaSerTextView {
            if textView.text.isEmpty {
                textView.text = ""
            }
        }
        
    }
    
    
    
    
    // Metodos para guardar y subir foto
    
    @IBAction func botonSubirFotoTransparente(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let imagenSeleccionada: UIImage = image
        
        imagenSubirFoto.image = imagenSeleccionada
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Botones de formulario Mi Meta
    
    @IBAction func botonFechaInicio(sender: AnyObject) {
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.center = blurView.center
        calendar.dataSource = self
        calendar.delegate = self
        blurView.addSubview(calendar)
        self.calendario1 = calendar
        
    }
    
    @IBAction func botonFechaTermino(sender: AnyObject) {
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.center = blurView.center
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        blurView.addSubview(calendar)
        self.calendario2 = calendar
        
        
    }
    
    @IBAction func botonAhorroDeberaSer(sender: AnyObject) {
    }
    
    
    @IBAction func botonFrecuenciaAhorro(sender: AnyObject) {
    }
    
    
    @IBAction func botonGuardar(sender: AnyObject) {
        
        if nombreMiMetaTextView.text == "" || nombreMiMetaTextView.text == "Nombre de Mi Meta" {
            
            mostraMSJ("Por favor ponle un nombre a tu meta")
            
        } else if cantidadAhorrarTextView.text == "" {
            
            mostraMSJ("Porfavor agrega una cantidad a tu meta")
            
        } else if fechaInicioLabel.text == "" || fechaTerminoLabel.text == "" {
            
            mostraMSJ("Porfavor agrega una fecha Inicio/Termino a tu meta")
            
        } else if ahorroDeberaSerTextView.text == "" {
            
            mostraMSJ("Porfavor cheque que todos sus datos sean correctos")
            
        } else {
            
            print("OK")
            
            // Guardar Imagen de Meta
            let myImageName = "imagenMeta.png"
            let imagePath = fileInDocumentsDirectory(myImageName)
            
            if let image = imagenSubirFoto.image {
                saveImage(image, path: imagePath)
            } else { print("Hubo un error al guardar su foto de Meta") }
            
            if let loadedImage = loadImageFromPath(imagePath) {
                print(" Loaded Image: \(loadedImage)")
            } else { print("some error message 2") }

            
            //Fecha Inicial
            var fechaIni: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.stringFromDate(fechaInicio)
            }
            
            //Fecha Final
            var fechaFinal: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.stringFromDate(fechaTermino)
            }
            
            let nombre = nombreMiMetaTextView.text
            let montoMeta = cantidadAhorrarTextView.text
            let montoAhorrar = ahorroDeberaSerTextView.text
            
            print("Nombre de meta es \(nombreMiMetaTextView.text)")
            print("Fecha de inicio " + fechaIni)
            print("Fecha de termino " + fechaFinal)
            print("Monto de meta es \(cantidadAhorrarTextView.text)")
            print("A ahorrar de meta es \(ahorroDeberaSerTextView.text)")
            
            let id: String = String(idUsuario)
            
            self.insertarMeta(id, nombreMeta: nombre, fechaInicio: fechaIni, fechaFinal: fechaFinal, montoMeta: montoMeta, montoAhorrar: montoAhorrar)
            
            
        }
        
        
        
    }
    
    
    // Metodos delegados FSCalendar
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        
        
        if calendar == self.calendario1 {
            
            var shortDate: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.stringFromDate(date)
            }
            
            print(shortDate)
            
            fecha = shortDate
            fechaInicioLabel.text = fecha
            
            fechaInicio = date
            print("La fecha de inicio \(fechaInicio)")
            print("La fecha de termino \(fechaTermino)")
            
            calendar.hidden = true
            blurView.hidden = true
            
            // Calculando diferencia de dias
            let calendariosDiferenciadeDias: NSCalendar = NSCalendar.currentCalendar()
            
            let date1 = calendariosDiferenciadeDias.startOfDayForDate(fechaInicio)
            let date2 = calendariosDiferenciadeDias.startOfDayForDate(fechaTermino)
            
            let flags = NSCalendarUnit.Day
            let components = calendariosDiferenciadeDias.components(flags, fromDate: date1, toDate: date2, options: [])
            
            print("Los dias entre ellos son \(components.day)")
            
            self.diferenciaDeDias = components.day
            print("Los dias entre ellos son \(self.diferenciaDeDias)")
            
            // Calcular el monto sobre los dias
            if let cantidad : Int = Int(cantidadAhorrarTextView.text) {
                
                if diferenciaDeDias <= 0 {
                    
                    // mostraMSJ("Tu dia de termino no puede ser menor o igual ala fecha de inicio")
                    
                } else {
                    
                    if let montoAhorrar: Int = cantidad / diferenciaDeDias {
                        self.ahorroDeberaSerTextView.text = String(montoAhorrar)
                    }
                    
                }
                
            }
            
            
            
        } else if calendar == self.calendario2 {
            
            var shortDate: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.stringFromDate(date)
            }
            
            print(shortDate)
            
            fecha = shortDate
            fechaTerminoLabel.text = fecha
            
            fechaTermino = date
            print("La fecha de inicio \(fechaInicio)")
            print("La fecha de termino \(fechaTermino)")
            
            
            // Calculando diferencia de dias
            let calendariosDiferenciadeDias: NSCalendar = NSCalendar.currentCalendar()
            
            let date1 = calendariosDiferenciadeDias.startOfDayForDate(fechaInicio)
            let date2 = calendariosDiferenciadeDias.startOfDayForDate(fechaTermino)
            
            let flags = NSCalendarUnit.Day
            let components = calendariosDiferenciadeDias.components(flags, fromDate: date1, toDate: date2, options: [])
            
            print("Los dias entre ellos son \(components.day)")
            
            self.diferenciaDeDias = components.day
            print("Los dias entre ellos son \(self.diferenciaDeDias)")
            
            // Calcular el monto sobre los dias
            if let cantidad : Int = Int(cantidadAhorrarTextView.text) {
                
                if diferenciaDeDias <= 0 {
                    
                    mostraMSJ("Tu dia de termino no puede ser menor o igual ala fecha de inicio")
                    
                } else {
                    
                    if let montoAhorrar: Int = cantidad / diferenciaDeDias {
                        self.ahorroDeberaSerTextView.text = String(montoAhorrar)
                    }
                    
                }
                
            }
            
            
            calendar.hidden = true
            blurView.hidden = true
        }
        
    }
    
    func minimumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        
        let date = NSDate()
        let calendario = NSCalendar.currentCalendar()
        let components = calendario.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return calendar.dateWithYear(year, month: month, day: day)
    }
    
    
    // Metodo para insertar meta en base de datos
    
    func insertarMeta(id: String, nombreMeta: String, fechaInicio: String, fechaFinal: String, montoMeta: String, montoAhorrar: String) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Iniciar Loader
            JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Guardando su Meta", andFooter: "Por favor espere...")
        })
        
        let customAllowedSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let nombre = nombreMeta.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        let urlString = "http://intercubo.com/aprendeycrece/api/insertarMeta.php?idUsuario=" + id + "&nombreMeta=" + nombre + "&fechaInicio=" + fechaInicio + "&fechaTermino=" + fechaFinal + "&montoMeta=" + montoMeta + "&montoMinimo=" + montoAhorrar
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                        
                        print(jsonResponse)
                        
                        if jsonResponse.count > 0 {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                                let alertView = SCLAlertView()
                                alertView.showCloseButton = false
                                alertView.addButton("Aceptar") {
                                    print("Boton Aceptar")
                                    
                                    self.performSegueWithIdentifier("SegueDesdeMetaInicial", sender: self)
                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "MetaInicialGuardada")
                                }
                                
                                alertView.showSuccess("Aprende y Crece", subTitle: "Su Meta se ha guardado exitosamente")
                                
                            })

                            
                            
                            
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                                let alertView = SCLAlertView()
                                alertView.showCloseButton = true
                                
                                alertView.showError("Aprende y Crece", subTitle: "Ha habido un problema al guardar su Meta, porfavor intente nuevamente mas tarde")
                            })
                            
                        }

                        
                    } catch {
                        
                        
                    }
                    
                    
                } else {
                    
                    print("Hubo un problema al obtener data")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Iniciar Loader
                        JHProgressHUD.sharedHUD.hide()
                    })
                    
                }
                
                
            })
            
            task.resume()
            
        } else {
            
            print("Hubo un problema al obtener la url")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Iniciar Loader
                JHProgressHUD.sharedHUD.hide()
            })
            
        }
        
        
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

//Guardar Fotos

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

func saveImage (image: UIImage, path: String ) -> Bool{
    
    let pngImageData = UIImagePNGRepresentation(image)
    //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = pngImageData!.writeToFile(path, atomically: true)
    
    return result
    
}

func loadImageFromPath(path: String) -> UIImage? {
    
    let image = UIImage(contentsOfFile: path)
    
    if image == nil {
        
        print("missing image at: \(path)")
    }
    print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
    return image
    
}

