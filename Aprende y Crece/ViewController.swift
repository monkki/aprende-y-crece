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
    
    @IBOutlet var imagenMarcadorLunes: UIImageView!
    @IBOutlet var imagenMarcadorMartes: UIImageView!
    @IBOutlet var imagenMarcadorMiercoles: UIImageView!
    @IBOutlet var imagenMarcadorJueves: UIImageView!
    @IBOutlet var imagenMarcadorViernes: UIImageView!
    @IBOutlet var imagenMarcadorSabado: UIImageView!
    @IBOutlet var imagenMarcadorDomingo: UIImageView!
    
    
    // Variables de Gauges
    var ingreso_lunes = "0"
    var ingreso_martes = "0"
    var ingreso_miercoles = "0"
    var ingreso_jueves = "0"
    var ingreso_viernes = "0"
    var ingreso_sabado = "0"
    var ingreso_domingo = "0"
    
    var egreso_lunes = "0"
    var egreso_martes = "0"
    var egreso_miercoles = "0"
    var egreso_jueves = "0"
    var egreso_viernes = "0"
    var egreso_sabado = "0"
    var egreso_domingo = "0"

    
    
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
        
        let ingreso: Float = Float(self.ingreso_lunes)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge lunes es  \(monto)")
        
        self.gaugeIngresoLunes.rate = CGFloat(monto * 4)
    }
    
    func GaugeIMartes() {
        
        let ingreso: Float = Float(self.ingreso_martes)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge martes es  \(monto)")

        self.gaugeIngresoMartes.rate = CGFloat(monto * 4)
    }
    
    func GaugeIMiercoles() {
        
        let ingreso: Float = Float(self.ingreso_miercoles)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge miercoles es  \(monto)")
        
        self.gaugeIngresoMiercoles.rate = CGFloat(monto * 4)
    }
    
    func GaugeIJueves() {
        
        let ingreso: Float = Float(self.ingreso_jueves)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge jueves es  \(monto)")
        
        self.gaugeIngresoJueves.rate = CGFloat(monto * 4)
    }
    
    func GaugeIViernes() {
        
        let ingreso: Float = Float(self.ingreso_viernes)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge viernes es  \(monto)")
        
        self.gaugeIngresoViernes.rate = CGFloat(monto * 4)
    }
    
    func GaugeISabado() {
        
        let ingreso: Float = Float(self.ingreso_sabado)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge sabado es  \(monto)")
        
        self.gaugeIngresoSabado.rate = CGFloat(monto * 4)
    }
    
    func GaugeIDomingo() {
        
        let ingreso: Float = Float(self.ingreso_domingo)!
        
        let monto: Float = ((ingreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge domingo es  \(monto)")
        
        self.gaugeIngresoDomingo.rate = CGFloat(monto * 4)
    }
    
    func GaugeELunes() {
        
        let egreso: Float = Float(self.egreso_lunes)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso lunes es  \(monto)")
        
        self.gaugeEgresoLunes.rate = CGFloat(monto * 4)
    }
    
    func GaugeEMartes() {
        
        let egreso: Float = Float(self.egreso_martes)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso martes es  \(monto)")
        
        self.gaugeEgresoMartes.rate = CGFloat(monto * 4)
    }
    
    func GaugeEMiercoles() {
        
        let egreso: Float = Float(self.egreso_miercoles)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso miercoles es  \(monto)")
        
        self.gaugeEgresoMiercoles.rate = CGFloat(monto * 4)
    }
    
    func GaugeEJueves() {
        
        let egreso: Float = Float(self.egreso_jueves)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso jueves es  \(monto)")
        
        self.gaugeEgresoJueves.rate = CGFloat(monto * 4)
    }
    
    func GaugeEViernes() {
        
        let egreso: Float = Float(self.egreso_viernes)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso viernes es  \(monto)")
        
        self.gaugeEgresoViernes.rate = CGFloat(monto * 4)
    }
    
    func GaugeESabado() {
        
        let egreso: Float = Float(self.egreso_sabado)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso sabado es  \(monto)")
        
        self.gaugeEgresoSabado.rate = CGFloat(monto * 4)
    }
    
    func GaugeEDomingo() {
        
        let egreso: Float = Float(self.egreso_domingo)!
        
        let monto: Float = ((egreso * 100) / Float(self.montoMeta)!) * 0.1
        
        print("Medidor de gauge egreso domingo es  \(monto)")
        
        self.gaugeEgresoDomingo.rate = CGFloat(monto * 4)
    }
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func obtenerDatosMeta() {
        
        let urlString = "http://intercubo.com/aprendeycrece/api/diasSemana.php?idUsuario=" + String(idUsuario)
        
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
                                
                        // INGRESOS
                                
                                if let ingreso_lunes = json["ingreso_lunes"] as? String {
                                    self.ingreso_lunes = ingreso_lunes
                                } else if let _ = json["ingreso_lunes"] as? NSNull {
                                    self.ingreso_lunes = "0"
                                }
                                
                                if let ingreso_martes = json["ingreso_martes"] as? String {
                                    self.ingreso_martes = ingreso_martes
                                } else if let _ = json["ingreso_martes"] as? NSNull {
                                    self.ingreso_martes = "0"
                                }
                                
                                if let ingreso_miercoles = json["ingreso_miercoles"] as? String {
                                    self.ingreso_miercoles = ingreso_miercoles
                                } else if let _ = json["ingreso_miercoles"] as? NSNull {
                                    self.ingreso_miercoles = "0"
                                }

                                if let ingreso_jueves = json["ingreso_jueves"] as? String {
                                    self.ingreso_jueves = ingreso_jueves
                                } else if let _ = json["ingreso_jueves"] as? NSNull {
                                    self.ingreso_jueves = "0"
                                }
                                
                                if let ingreso_viernes = json["ingreso_viernes"] as? String {
                                    self.ingreso_viernes = ingreso_viernes
                                } else if let _ = json["ingreso_viernes"] as? NSNull {
                                    self.ingreso_viernes = "0"
                                }
                                
                                if let ingreso_sabado = json["ingreso_sabado"] as? String {
                                    self.ingreso_sabado = ingreso_sabado
                                } else if let _ = json["ingreso_sabado"] as? NSNull {
                                    self.ingreso_sabado = "0"
                                }
                                
                                if let ingreso_domingo = json["ingreso_domingo"] as? String {
                                    self.ingreso_domingo = ingreso_domingo
                                } else if let _ = json["ingreso_domingo"] as? NSNull {
                                    self.ingreso_domingo = "0"
                                }

                        // EGRESOS
                                
                                if let egreso_lunes = json["egreso_lunes"] as? String {
                                    self.egreso_lunes = egreso_lunes
                                } else if let _ = json["egreso_lunes"] as? NSNull {
                                    self.egreso_lunes = "0"
                                }
                                
                                if let egreso_martes = json["egreso_martes"] as? String {
                                    self.egreso_martes = egreso_martes
                                } else if let _ = json["egreso_martes"] as? NSNull {
                                    self.egreso_martes = "0"
                                }
                                
                                if let egreso_miercoles = json["egreso_miercoles"] as? String {
                                    self.egreso_miercoles = egreso_miercoles
                                } else if let _ = json["egreso_miercoles"] as? NSNull {
                                    self.egreso_miercoles = "0"
                                }
                                
                                if let egreso_jueves = json["egreso_jueves"] as? String {
                                    self.egreso_jueves = egreso_jueves
                                } else if let _ = json["egreso_jueves"] as? NSNull {
                                    self.egreso_jueves = "0"
                                }
                                
                                if let egreso_viernes = json["egreso_viernes"] as? String {
                                    self.egreso_viernes = egreso_viernes
                                } else if let _ = json["egreso_viernes"] as? NSNull {
                                    self.egreso_viernes = "0"
                                }
                                
                                if let egreso_sabado = json["egreso_sabado"] as? String {
                                    self.egreso_sabado = egreso_sabado
                                } else if let _ = json["egreso_sabado"] as? NSNull {
                                    self.egreso_sabado = "0"
                                }
                                
                                if let egreso_domingo = json["egreso_domingo"] as? String {
                                    self.ingreso_domingo = egreso_domingo
                                } else if let _ = json["egreso_domingo"] as? NSNull {
                                    self.egreso_domingo = "0"
                                }
                                
                                

                                /*
                                
                                ((monto * 100) / metaTotal) * 0.1
                                
                                print(self.ingreso_lunes)
                                print(self.ingreso_martes)
                                print(self.ingreso_miercoles)
                                print(self.ingreso_jueves)
                                print(self.ingreso_viernes)
                                print(self.ingreso_sabado)
                                print(self.ingreso_domingo)
                                
                                print(self.egreso_lunes)
                                print(self.egreso_martes)
                                print(self.egreso_miercoles)
                                print(self.egreso_jueves)
                                print(self.egreso_viernes)
                                print(self.egreso_sabado)
                                print(self.egreso_domingo)
                                */
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.nombreMetaLabel.text = self.nombreMeta
                                    self.cantidadTotalMetaLabel.text = "Meta: $ " + self.montoMeta
                                    self.fechaTerminoLabel.text = "Fecha limite: \(self.fechaTermino)"
                                    self.montoAhorrarLabel.text = "dia $" + self.montoMinimo
                                    
                                    if self.ingreso_lunes > self.egreso_lunes {
                                        self.imagenMarcadorLunes.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorLunes.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_martes > self.egreso_martes {
                                        self.imagenMarcadorMartes.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorMartes.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_miercoles > self.egreso_miercoles {
                                        self.imagenMarcadorMiercoles.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorMiercoles.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_jueves > self.egreso_jueves {
                                        self.imagenMarcadorJueves.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorJueves.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_viernes > self.egreso_viernes {
                                        self.imagenMarcadorViernes.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorViernes.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_sabado > self.egreso_sabado {
                                        self.imagenMarcadorSabado.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorSabado.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    if self.ingreso_domingo > self.egreso_domingo {
                                        self.imagenMarcadorDomingo.image = UIImage(named: "indicadorPalomita")
                                    } else {
                                        self.imagenMarcadorDomingo.image = UIImage(named: "indicadorCruz")
                                    }
                                    
                                    
                                    NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.GaugeILunes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(ViewController.GaugeIMartes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(ViewController.GaugeIMiercoles), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.GaugeIJueves), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(ViewController.GaugeIViernes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(ViewController.GaugeISabado), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(ViewController.GaugeIDomingo), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(ViewController.GaugeELunes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.GaugeEMartes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: #selector(ViewController.GaugeEMiercoles), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(ViewController.GaugeEJueves), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(ViewController.GaugeEViernes), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.4, target: self, selector: #selector(ViewController.GaugeESabado), userInfo: nil, repeats: false)
                                    NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.GaugeEDomingo), userInfo: nil, repeats: false)
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

