//
//  MiCarteraViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 08/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import GaugeKit

class MiCarteraViewController: UIViewController {
    
    // IBOUTLETS
    @IBOutlet var ActualizadoLabel: UILabel!
    @IBOutlet var reporteSegmentedControl: UISegmentedControl!
    @IBOutlet var actualmenteTengoLabel: UICountingLabel!
    @IBOutlet var miPresupuestoEstimadoGauge: Gauge!
    @IBOutlet var miPresupuestoEstimadoLabel: UICountingLabel!
    @IBOutlet var ingresoLabel: UICountingLabel!
    @IBOutlet var miCarteraLabel: UICountingLabel!
    @IBOutlet var miCuentaBancariaLabel: UICountingLabel!
    @IBOutlet var egresoLabel: UICountingLabel!
    @IBOutlet var comidasEgresoLabel: UICountingLabel!
    @IBOutlet var comprasEgresoLabel: UICountingLabel!
    @IBOutlet var casaEgresoLabel: UICountingLabel!
    @IBOutlet var otrosEgresosLabel: UICountingLabel!
   
    // idUsuario
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    var actualmenteTengo = 0
    var ingresoTotal = 0
    var egresoTotal = 0
    
    //Datos Obtenidos de Ingresos
    var descripcionArrayIngesos = [String]()
    var fechaArrayIngresos = [String]()
    var idArrayIngresos = [String]()
    var ingresosArray = [String]()
    var motivoArrayIngresos = [String]()
    var repetirArrayIngresos = [String]()
    
    //Datos Obtenidos de Egresos
    var descripcionArrayEgesos = [String]()
    var fechaArrayEgresos = [String]()
    var idArrayEgresos = [String]()
    var egresosArray = [String]()
    var motivoArrayEgresos = [String]()
    var repetirArrayEgresos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        obtenerIngresos()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.miPresupuestoEstimadoGauge.rate = 0
        
    }
    
    func GaugePresupuestoEstimado(numero: Int) {
        self.miPresupuestoEstimadoGauge.rate = CGFloat(numero)
    }

    // ACCION DEL SEGMENTED CONTROLLER
    
    @IBAction func indexCambio(sender: AnyObject) {
        
        switch reporteSegmentedControl.selectedSegmentIndex {
            
        case 0:
            print("Index 0")
            obtenerIngresos()
        case 1:
            print("Index 1")
            obtenerIngresos()
        case 2:
            print("Index 2")
            obtenerIngresos()
        case 3:
            print("Index 3")
            obtenerIngresos()
        default:
            print("Hubo un problema con el index")
        }
    }
    
    
    
    //FUNCION PARA OBTENER INGRESOS
    
    func obtenerIngresos() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Obteniendo sus datos", andFooter: "Por favor espere...")
        }
        
        let urlString = "http://intercubo.com/aprendeycrece/api/obtenerMontos.php?idUsuario=" + String(idUsuario) + "&tipo=i"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        JHProgressHUD.sharedHUD.hide()
                    }
                    
                    do {
                        
                        self.obtenerEgresos()
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        self.descripcionArrayIngesos.removeAll()
                        self.fechaArrayIngresos.removeAll()
                        self.idArrayIngresos.removeAll()
                        self.ingresosArray.removeAll()
                        self.motivoArrayIngresos.removeAll()
                        self.repetirArrayIngresos.removeAll()
                        
                        if jsonResponse.count > 0 {
                            
                            
                            for json in jsonResponse {
                                
                                let descripcion = json["descripcion"] as! String
                                let fecha = json["fecha"] as! String
                                let id = json["id"] as! String
                                let monto = json["monto"] as! String
                                let motivo = json["motivo"] as! String
                                let repetir = json["repetir"] as! String
                                
                                self.descripcionArrayIngesos.append(descripcion)
                                self.fechaArrayIngresos.append(fecha)
                                self.idArrayIngresos.append(id)
                                self.ingresosArray.append(monto)
                                self.motivoArrayIngresos.append(motivo)
                                self.repetirArrayIngresos.append(repetir)
                                
                            }
                            
                            print(self.descripcionArrayIngesos)
                            print(self.fechaArrayIngresos)
                            print(self.idArrayIngresos)
                            print(self.ingresosArray)
                            print(self.motivoArrayIngresos)
                            print(self.repetirArrayIngresos)
                            
                            // PENDIENTES DE AGREGAR VALORES
                            self.miPresupuestoEstimadoLabel.countFrom(0, endValue: 0.00, duration: 1.5)
                            self.miCarteraLabel.countFrom(0, endValue: 0, duration: 1.5)
                            self.miCuentaBancariaLabel.countFrom(0, endValue: 0, duration: 1.5)
                            
                            // Se convierte el arreglos de ingresos de String a Int
                            let array = self.ingresosArray
                            let igresosArrayEnteros = array.map { Int($0)!}
                            print(igresosArrayEnteros)
                            
                            // Se suma el arreglo de ingresos
                            let sumaDeIngresosTotales = igresosArrayEnteros
                            let suma = sumaDeIngresosTotales.reduce(0, combine: +)
                            print("La suma es \(suma)")
                            
                            self.ingresoTotal = suma
                            
                            self.ingresoLabel.countFrom(0, endValue: CGFloat(suma), duration: 1.5)
                            
                            
                            
                            // Se obtiene el index de Arreglo donde haya Comida y se suman
                            var sumaDeComida = 0
                            for var i = 0; i < self.motivoArrayIngresos.count; i++ {
                                let comidas = "Comida"
                                
                                if comidas == self.motivoArrayIngresos[i] {
                                    
                                    sumaDeComida += igresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de comida es \(sumaDeComida)")
                            
                            
                            
                            // Se obtiene el index de Arreglo donde haya Casa y se suman
                            var sumaDeCasa = 0
                            for var i = 0; i < self.motivoArrayIngresos.count; i++ {
                                let casa = "Casa"
                                
                                if casa == self.motivoArrayIngresos[i] {
                                    
                                    sumaDeCasa += igresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de casa es \(sumaDeCasa)")
                            
                            
                            // Se obtiene el index de Arreglo donde haya Compras y se suman
                            var sumaDeCompras = 0
                            for var i = 0; i < self.motivoArrayIngresos.count; i++ {
                                let compras = "Compras"
                                
                                if compras == self.motivoArrayIngresos[i] {
                                    
                                    sumaDeCompras += igresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de compras es \(sumaDeCompras)")
                            
                            
                            // Se obtiene el index de Arreglo donde haya Compras y se suman
                            var sumaDeOtros = 0
                            for var i = 0; i < self.motivoArrayIngresos.count; i++ {
                                let otros = "Otro"
                                
                                if otros == self.motivoArrayIngresos[i] {
                                    
                                    sumaDeOtros += igresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de otros es \(sumaDeOtros)")
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.GaugePresupuestoEstimado(5)
                            })
                            
                            
                        } else {
                            
                            print("No hay datos en respuesta Json")
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                JHProgressHUD.sharedHUD.hide()
                            }
                            
                        }
                        
                        //print(jsonResponse)
                        
                    } catch {
                        
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            JHProgressHUD.sharedHUD.hide()
                        }
                        
                    }
                    
                } else {
                
                    print("Hubo un problema al obtener los datos")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        JHProgressHUD.sharedHUD.hide()
                    }
                    
                }
                
            })
            
            task.resume()
            
        } else {
            
            print("Hubo un problema al crear la URL")
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                JHProgressHUD.sharedHUD.hide()
            }
            
        }
        
        
    }

    
    //FUNCION PARA OBTENER INGRESOS
    
    func obtenerEgresos() {
        
        let urlString = "http://intercubo.com/aprendeycrece/api/obtenerMontos.php?idUsuario=" + String(idUsuario) + "&tipo=e"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    do {
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        self.descripcionArrayEgesos.removeAll()
                        self.fechaArrayEgresos.removeAll()
                        self.idArrayEgresos.removeAll()
                        self.egresosArray.removeAll()
                        self.motivoArrayEgresos.removeAll()
                        self.repetirArrayEgresos.removeAll()
                        
                        if jsonResponse.count > 0 {
                            
                            
                            for json in jsonResponse {
                                
                                let descripcion = json["descripcion"] as! String
                                let fecha = json["fecha"] as! String
                                let id = json["id"] as! String
                                let monto = json["monto"] as! String
                                let motivo = json["motivo"] as! String
                                let repetir = json["repetir"] as! String
                                
                                self.descripcionArrayEgesos.append(descripcion)
                                self.fechaArrayEgresos.append(fecha)
                                self.idArrayEgresos.append(id)
                                self.egresosArray.append(monto)
                                self.motivoArrayEgresos.append(motivo)
                                self.repetirArrayEgresos.append(repetir)
                                
                            }
                            
                            print(self.descripcionArrayEgesos)
                            print(self.fechaArrayEgresos)
                            print(self.idArrayEgresos)
                            print(self.egresosArray)
                            print(self.motivoArrayEgresos)
                            print(self.repetirArrayEgresos)
                            
                            
                            // Se convierte el arreglos de ingresos de String a Int
                            let array = self.egresosArray
                            let egresosArrayEnteros = array.map { Int($0)!}
                            print(egresosArrayEnteros)
                            
                            // Se suma el arreglo de egresos
                            let sumaDeEgresos = egresosArrayEnteros
                            let suma = sumaDeEgresos.reduce(0, combine: +)
                            print("La suma es \(suma)")
                            
                            self.egresoTotal = suma
                            
                            self.actualmenteTengo = (self.ingresoTotal - self.egresoTotal)
                            
                            self.actualmenteTengoLabel.countFrom(0, endValue: CGFloat(self.actualmenteTengo), duration: 1.5)
                            
                            // Egresos Label
                            self.egresoLabel.countFrom(0, endValue: CGFloat(suma), duration: 1.5)
                            
                            
                            // Se obtiene el index de Arreglo donde haya Comida y se suman
                            var sumaDeComida = 0
                            for var i = 0; i < self.motivoArrayEgresos.count; i++ {
                                let comidas = "Comida"
                                
                                if comidas == self.motivoArrayEgresos[i] {
                                    
                                    sumaDeComida += egresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de comida es \(sumaDeComida)")
                            
                            self.comidasEgresoLabel.countFrom(0, endValue: CGFloat(sumaDeComida), duration: 1.5)
                            
                            
                            // Se obtiene el index de Arreglo donde haya Casa y se suman
                            var sumaDeCasa = 0
                            for var i = 0; i < self.motivoArrayEgresos.count; i++ {
                                let casa = "Casa"
                                
                                if casa == self.motivoArrayEgresos[i] {
                                    
                                    sumaDeCasa += egresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de casa es \(sumaDeCasa)")
                            
                            self.casaEgresoLabel.countFrom(0, endValue: CGFloat(sumaDeCasa), duration: 1.5)
                            
                            
                            // Se obtiene el index de Arreglo donde haya Compras y se suman
                            var sumaDeCompras = 0
                            for var i = 0; i < self.motivoArrayEgresos.count; i++ {
                                let compras = "Compras"
                                
                                if compras == self.motivoArrayEgresos[i] {
                                    
                                    sumaDeCompras += egresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de compras es \(sumaDeCompras)")
                            
                            self.comprasEgresoLabel.countFrom(0, endValue: CGFloat(sumaDeCompras), duration: 1.5)
                            
                            
                            // Se obtiene el index de Arreglo donde haya Compras y se suman
                            var sumaDeOtros = 0
                            for var i = 0; i < self.motivoArrayEgresos.count; i++ {
                                let otros = "Otro"
                                
                                if otros == self.motivoArrayEgresos[i] {
                                    
                                    sumaDeOtros += egresosArrayEnteros[i]
                                    
                                }
                                
                            }
                            
                            print("La suma de otros es \(sumaDeOtros)")
                            
                            self.otrosEgresosLabel.countFrom(0, endValue: CGFloat(sumaDeOtros), duration: 1.5)
                            
                            
                        } else {
                            
                            print("No hay datos en respuesta Json")
                            
                        }
                        
                        //print(jsonResponse)
                        
                    } catch {
                        
                    }
                    
                } else {
                    
                    print("Hubo un problema al obtener los datos")
                    
                }
                
            })
            
            task.resume()
            
        } else {
            
            print("Hubo un problema al crear la URL")
            
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

// Extension para convertir HTML a String
extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

// Extension para convertir URL a ImageView
extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}

