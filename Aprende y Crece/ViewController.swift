//
//  ViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 05/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import GaugeKit

class ViewController: UIViewController {
    
    
    //IBOUTLETS
    @IBOutlet var fotoMeta: UIImageView!
    @IBOutlet var nombreMetaLabel: UILabel!
    @IBOutlet var cantidadTotalMetaLabel: UILabel!
    @IBOutlet var fechaTerminoLabel: UILabel!
    @IBOutlet var montoAhorrarLabel: UILabel!
    
    
    //Variables
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    
    var fechaInicio = ""
    var fechaTermino = ""
    var montoMeta = ""
    var montoMinimo = ""
    var nombreMeta = ""
    
    //GAUGES INGRESOS
    @IBOutlet var gaugeIngresoLunes: Gauge!
    @IBOutlet var gaugeIngresoMartes: Gauge!
    @IBOutlet var gaugeIngresoMiercoles: Gauge!
    @IBOutlet var gaugeIngresoJueves: Gauge!
    @IBOutlet var gaugeIngresoViernes: Gauge!
    @IBOutlet var gaugeIngresoSabado: Gauge!
    @IBOutlet var gaugeIngresoDomingo: Gauge!
    
    
    
    
    // URL REGISTRAR MANUAL  http://intercubo.com/aprendeycrece/api/registra.php?n=Roberto&c=rgutierrezgonzalez@hotmail.com&p=swamphell&nickname=monki&fecha=24
    
    //URL REGISTRAR FACEBOOK http://intercubo.com/aprendeycrece/api/registra.php?n=Roberto&c=rgutierrezgonzalez@hotmail.com&fbid=1234&p=1234
    
    //URL PARA INSERTAR INGRESOS
    // http://intercubo.com/aprendeycrece/api/ingreso.php?idUsuario=1234&ingreso=250&motivo=paragastos&fecha=24Marzo&descripcion=prueba&repetir=si
    
    //URL PARA INSERTAR EGRESOS
    // http://intercubo.com/aprendeycrece/api/egreso.php?idUsuario=1234&egreso=250&motivo=paragastos&fecha=24Marzo&descripcion=prueba&repetir=si
    
    //URL PARA OBTENER INGRESOS
    // http://intercubo.com/aprendeycrece/api/obtenerIngresos.php?idUsuario=1234
    
    //URL PARA OBTENER EGRESOS
    // http://intercubo.com/aprendeycrece/api/obtenerEgresos.php?idUsuario=1234
    
    
    //URL PARA OBTENER META
    // http://intercubo.com/aprendeycrece/api/obtenerMeta.php?idUsuario=1234
    
    
    
    //GAUGES EGRESOS
    @IBOutlet var gaugeEgresoLunes: Gauge!
    @IBOutlet var gaugeEgresoMartes: Gauge!
    @IBOutlet var gaugeEgresoMiercoles: Gauge!
    @IBOutlet var gaugeEgresoJueves: Gauge!
    @IBOutlet var gaugeEgresoViernes: Gauge!
    @IBOutlet var gaugeEgresoSabado: Gauge!
    @IBOutlet var gaugeEgresoDomingo: Gauge!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ACOMODO GAUGE INGRESOS
        gaugeIngresoLunes.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoMartes.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoMiercoles.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoJueves.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoViernes.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoSabado.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        gaugeIngresoDomingo.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        //ACOMODO GAUGE EGRESOS
        gaugeEgresoLunes.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoMartes.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoMiercoles.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoJueves.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoViernes.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoSabado.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        gaugeEgresoDomingo.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
       

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Guardar Imagen de Meta
        let myImageName = "imagenMeta.png"
        let imagePath = fileInDocumentsDirectory(myImageName)
        
        
        if let loadedImage = loadImageFromPath(imagePath) {
            print(" Loaded Image: \(loadedImage)")
            
            self.fotoMeta.image = loadedImage
            
        } else { print("Hubo un error al obtener su foto de Meta") }

        
        obtenerDatosMeta()
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "GaugeILunes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "GaugeIMartes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "GaugeIMiercoles", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "GaugeIJueves", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "GaugeIViernes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "GaugeISabado", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "GaugeIDomingo", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "GaugeELunes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "GaugeEMartes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: "GaugeEMiercoles", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: "GaugeEJueves", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: "GaugeEViernes", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.4, target: self, selector: "GaugeESabado", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "GaugeEDomingo", userInfo: nil, repeats: false)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.gaugeIngresoLunes.rate = 0
        self.gaugeIngresoMartes.rate = 0
        self.gaugeIngresoMiercoles.rate = 0
        self.gaugeIngresoJueves.rate = 0
        self.gaugeIngresoViernes.rate = 0
        self.gaugeIngresoSabado.rate = 0
        self.gaugeIngresoDomingo.rate = 0
        self.gaugeEgresoLunes.rate = 0
        self.gaugeEgresoMartes.rate = 0
        self.gaugeEgresoMiercoles.rate = 0
        self.gaugeEgresoJueves.rate = 0
        self.gaugeEgresoViernes.rate = 0
        self.gaugeEgresoSabado.rate = 0
        self.gaugeEgresoDomingo.rate = 0

    }
    
    func GaugeILunes() {
        self.gaugeIngresoLunes.rate = 2
    }
    
    func GaugeIMartes() {
        self.gaugeIngresoMartes.rate = 9
    }
    
    func GaugeIMiercoles() {
        self.gaugeIngresoMiercoles.rate = 6
    }
    
    func GaugeIJueves() {
        self.gaugeIngresoJueves.rate = 1
    }
    
    func GaugeIViernes() {
        self.gaugeIngresoViernes.rate = 3
    }
    
    func GaugeISabado() {
        self.gaugeIngresoSabado.rate = 8
    }
    
    func GaugeIDomingo() {
        self.gaugeIngresoDomingo.rate = 4
    }
    
    func GaugeELunes() {
        self.gaugeEgresoLunes.rate = 9
    }
    
    func GaugeEMartes() {
        self.gaugeEgresoMartes.rate = 3
    }
    
    func GaugeEMiercoles() {
        self.gaugeEgresoMiercoles.rate = 7
    }
    
    func GaugeEJueves() {
        self.gaugeEgresoJueves.rate = 8
    }
    
    func GaugeEViernes() {
        self.gaugeEgresoViernes.rate = 1
    }
    
    func GaugeESabado() {
        self.gaugeEgresoSabado.rate = 2
    }
    
    func GaugeEDomingo() {
        self.gaugeEgresoDomingo.rate = 9
    }
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func obtenerDatosMeta() {
        
        let urlString = "http://intercubo.com/aprendeycrece/api/obtenerMeta.php?idUsuario=" + String(idUsuario)
        
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
                            
                            print(jsonResponse)
                            
                            for json in jsonResponse {
                                
                                self.fechaInicio = json["fechaInicio"] as! String
                                self.fechaTermino = json["fechaTermino"] as! String
                                self.montoMeta = json["montoMeta"] as! String
                                self.montoMinimo = json["montoMinimo"] as! String
                                self.nombreMeta = json["nombreMeta"] as! String
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.nombreMetaLabel.text = self.nombreMeta
                                    self.cantidadTotalMetaLabel.text = "Meta: $ " + self.montoMeta
                                    self.fechaTerminoLabel.text = "Fecha limite: \(self.fechaTermino)"
                                    self.montoAhorrarLabel.text = "dia $" + self.montoMinimo
                                    
                                })
                                
                                
                            }
                            
                        }
                        
                    } catch {
                        
                        
                    }
                    
                    
                } else {
                    
                    print("Hubo un problema al crear data")
                    
                }
                
                
                
            })
            
            task.resume()
            
        } else {
            
            print("Hubo un problema al crear la URL")
            
        }
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "modificarMetaSegue" {
            
            let destinoVC = segue.destinationViewController as! MiMetaViewController
            destinoVC.fechaFinal = fechaTermino
            destinoVC.fechaIni = fechaInicio
            destinoVC.montoMeta = montoMeta
            destinoVC.montoMinimo = montoMinimo
            destinoVC.nombreMeta = nombreMeta
        }
    }
    



}

