//
//  ViewController.swift
//  Profiling
//
//  Created by CARLOS EDUARDO GONZALEZ ALVAREZ on 10/17/18.
//  Copyright © 2018 CARLOS EDUARDO GONZALEZ ALVAREZ. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var butMemoryOverflow: UIButton!
    @IBOutlet weak var butImageMemoryOverflow: UIButton!
    @IBOutlet weak var butHttpRequest: UIButton!
    @IBOutlet weak var butInfiniteList: UIButton!

    @IBOutlet weak var tableView: UIView!
    var tableViewController : TableViewController!
    var listaPlatos = [Plato]();
    var copyListas = [[Plato]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        butMemoryOverflow.layer.cornerRadius = 5;
        butMemoryOverflow.clipsToBounds = true;
        butMemoryOverflow.layer.borderWidth = 1.0;
        butMemoryOverflow.layer.borderColor = UIColor.lightGray.cgColor;
        
        butImageMemoryOverflow.layer.cornerRadius = 5;
        butImageMemoryOverflow.clipsToBounds = true;
        butImageMemoryOverflow.layer.borderWidth = 1.0;
        butImageMemoryOverflow.layer.borderColor = UIColor.lightGray.cgColor;
        
        butHttpRequest.layer.cornerRadius = 5;
        butHttpRequest.clipsToBounds = true;
        butHttpRequest.layer.borderWidth = 1.0;
        butHttpRequest.layer.borderColor = UIColor.lightGray.cgColor;
        
        butInfiniteList.layer.cornerRadius = 5;
        butInfiniteList.clipsToBounds = true;
        butInfiniteList.layer.borderWidth = 1.0;
        butInfiniteList.layer.borderColor = UIColor.lightGray.cgColor;
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        tableViewController = storyboard.instantiateViewController(withIdentifier: "tableVC") as? TableViewController
        
        self.addChild(tableViewController);
        tableView.addSubview(tableViewController.view);
        tableViewController.view.frame = tableView.bounds;
        tableViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableViewController.didMove(toParent: self)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.listaPlatos = [Plato]();
        for i in 1...1000000 {
            let p = Plato(id: i, nombre: String(i), precio: i, imagen: String(i))
            self.listaPlatos.append(p)
         }
        
    }


    @IBAction func didPressMemoryOverflow(_ sender: Any) {
        for i in 1...1000000 {
            self.copyListas.append(self.listaPlatos)
        }
        didPressMemoryOverflow("")
    }
    @IBAction func didPressImageMemoryOverflow(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        let imageView = UIImageView(frame:CGRect(x:0,y:0,width:bounds.size.width,height:bounds.size.height))
        let imageUrlString = "https://upload.wikimedia.org/wikipedia/commons/d/d2/Carlos_V_en_M%C3%BChlberg%2C_by_Titian%2C_from_Prado_in_Google_Earth.jpg?download"
        let imageUrl:URL = URL(string:imageUrlString)!;
        
        // Start background thread so that image loading does not make app unresponsive
        //DispatchQueue.global(qos: .userInitiated).async {
            
            //let imageData:NSData = NSData(contentsOf: imageUrl)!
            
            // When from background thread, UI needs to be updated on main_queue
            //DispatchQueue.main.async {
        //        let image = UIImage(data: imageData as Data)
        //        self.cell?.picture.setImage(image, for: .normal)
        //    }
        //}
        let imageData: NSData = NSData(contentsOf: imageUrl)!
        let image = UIImage(data: imageData as Data)
        imageView.image = image
        imageView.layer.masksToBounds = true;
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
            
        self.view = imageView;
    }
    @IBAction func didPressHttpRequest(_ sender: Any) {
        self.listaPlatos = []
        let url = URL(string:"http://demo7931028.mockable.io/platos")
        let task = URLSession.shared.dataTask(with:url!){(data, response,error) in
            guard let data = data else {return}
            do{
                guard let platos = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
                    print("error parseando JSON")
                    return
                }
                
                for p in platos {
                    let plato = Plato(fromJSON: p)
                    self.listaPlatos.append(plato);
                }
                
            } catch{
                print("error obteniendo json")
                return
            }
            print(String(data:data, encoding: .utf8)!)
            DispatchQueue.main.async {
                
                self.tableViewController.listaPlatos = self.listaPlatos
                self.tableViewController.tableView.reloadData()
            }
        }
        task.resume()
    }
    @IBAction func didPressInfiniteList(_ sender: Any) {
        self.listaPlatos = []
        let url = URL(string:"http://demo3573381.mockable.io/ruta")
        
        let task = URLSession.shared.dataTask(with:url!) {(data, response,error) in
            
            guard let array = data else {return}
            do{
                guard let platos = try JSONSerialization.jsonObject(with: array, options: []) as? [[String:Any]] else {
                    print("error parseando JSON")
                    return
                }
                
                    for p in platos {
                        let plato = Plato(fromJSON: p)
                        self.listaPlatos.append(plato);
                    }
                
            } catch{
                print("error obteniendo json")
                return
            }
            
            DispatchQueue.main.async {
                
                self.tableViewController.listaPlatos = self.listaPlatos
                self.tableViewController.tableView.reloadData()
            }
            
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        showToast(message: "Se ha excedido el uso de memoria")
        print("se ha excedido el uso de memoria")
        var platos = [Plato]()
        platos.append(Plato(id: 1, nombre: "Memory error", precio: 0, imagen: ""))
        self.tableViewController.listaPlatos = platos
            
        self.tableViewController.tableView.reloadData();
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

