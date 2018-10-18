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
    }


    @IBAction func didPressMemoryOverflow(_ sender: Any) {
        for i in 1...100000000 {
            self.listaPlatos = [Plato]();
            print(self.listaPlatos, i);
        }
    }
    @IBAction func didPressImageMemoryOverflow(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        let imageView = UIImageView(frame:CGRect(x:0,y:0,width:bounds.size.width,height:bounds.size.height))
        let imageUrlString = "https://upload.wikimedia.org/wikipedia/commons/a/af/Example_of_large_home_in_Southlake.JPG"
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
        let url = URL(string:"http://demo7931028.mockable.io/platos")
        print(url)
        URLSession.shared.dataTask(with:url!){(data, response,error) in
            guard let data = data else {return}
            print(String(data:data, encoding: .utf8)!)
        }
    }
    @IBAction func didPressInfiniteList(_ sender: Any) {
        
        let url = URL(string:"http://demo3573381.mockable.io/ruta")
        
        URLSession.shared.dataTask(with:url!) {(data, response,error) in
            
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
                self.tableViewController.listaPlatos = self.listaPlatos 
                self.tableViewController.tableView.reloadData()
                
            } catch{
                print("error obteniendo json")
                return
            }
            
            print(String(data:data!, encoding: .utf8)!)
        }
    }
}

