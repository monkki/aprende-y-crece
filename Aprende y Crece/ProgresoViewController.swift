//
//  ProgresoViewController.swift
//  Aprende y Crece
//
//  Created by Roberto Gutierrez on 24/02/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class ProgresoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var fechasArray = [String]()
    var ingresosArray = [String]()
    var egresosArray = [String]()
    var montoMeta: String = "0"
    
    var idUsuario = NSUserDefaults.standardUserDefaults().objectForKey("idUsuario") as! Int
    
    // Consulta para Progreso  SELECT i.fecha, (select sum(ingreso) from ingresos where fecha=i.fecha AND idUsuario="'.$idUsuario.'") as ingre, (select sum(egreso) from egresos where fecha=i.fecha AND idUsuario="'.$idUsuario.'") as egre from ingresos as i where i.idUsuario="'.$idUsuario.'" group by i.fecha
    
    @IBOutlet var tabla: UITableView!
    @IBOutlet var nombreMetaLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        obtenerJson()
    }
    
    func obtenerJson() {
        
        var nombre = ""
        
        let urlString = "http://intercubo.com/aprendeycrece/api/obtenerProgresoPersonal.php?idUsuario=" + String(idUsuario)
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if let data = data {
                    
                    do {
                        
                        
                        
                        self.fechasArray.removeAll()
                        self.ingresosArray.removeAll()
                        self.egresosArray.removeAll()
                        
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                        
                        print(jsonResponse)
                        
                        for json in jsonResponse {
                            
                            if let fecha = json["fecha"] as? String {
                                self.fechasArray.append(fecha)
                            }
                            
                            
                            if let meta = json["meta"] as? String {
                                self.montoMeta = meta
                            }
                            
                            if let nombreJson = json["nombre"] as? String {
                                nombre = nombreJson
                            }
                            
                            
                            if let ingreso = json["ingreso"] as? String {
                                self.ingresosArray.append(ingreso)
                            } else if let _ = json["ingreso"] as? NSNull {
                                let ingreso = "0"
                                self.ingresosArray.append(ingreso)
                            }
                            
                            
                            if let egreso = json["egreso"] as? String {
                                self.egresosArray.append(egreso)
                            } else if let _ = json["egreso"] as? NSNull {
                                let egreso = "0"
                                self.egresosArray.append(egreso)
                            }

                            

                        }
                        
                        print(self.fechasArray)
                        print(self.ingresosArray)
                        print(self.egresosArray)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.nombreMetaLabel.text = nombre
                            self.tabla.reloadData()
                        })
                        
                    } catch {
                        
                    }
                    
                } else {
                    
                    print("Hubo un problema al obtener data")
                    
                }
                
            })
            task.resume()
            
        } else {
            
            print("Hubo un problema al crear la URL")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fechasArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tabla.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath) as! ProgresoTableViewCell
        
        let diferencia: Int = Int(ingresosArray[indexPath.row])! - Int(egresosArray[indexPath.row])!
        
        cell.fechaLabel.text = fechasArray[indexPath.row]
        cell.ahorroLabel.text = "Su ahorro es \(diferencia)"
        
        self.montoMeta = String(Int(self.montoMeta)! - diferencia)
        
        cell.totalAhorroLabel.text = "$ \(self.montoMeta)" + ".00"
        
        if Int(ingresosArray[indexPath.row])! < Int(egresosArray[indexPath.row])! {
            cell.palomaOCruzImagen.image = UIImage(named: "cruzCheck")
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
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
