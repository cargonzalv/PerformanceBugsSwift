//
//  Plato.swift
//  Profiling
//
//  Created by CARLOS EDUARDO GONZALEZ ALVAREZ on 10/17/18.
//  Copyright © 2018 CARLOS EDUARDO GONZALEZ ALVAREZ. All rights reserved.
//

import CoreData
import CoreLocation
import Foundation
class Plato {
    var id: Int
    var nombre: String
    var precio: Int
    var imagen: String
    
    init(id: Int, nombre: String, precio: Int, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.precio = precio
        self.imagen = imagen
    }
    
    init(fromJSON dictionary: [String: Any]) {
        self.id = dictionary["id"] as! Int
        self.nombre = dictionary["nombre"] as! String
        self.precio = dictionary["precio"] as! Int
        self.imagen = dictionary["imagen"] as! String
    }
    
    init(fromEntity placeEntity: PlatoEntity) {
        self.id = Int(placeEntity.id)
        self.nombre = placeEntity.nombre!
        self.precio = Int(placeEntity.precio)
        self.imagen = placeEntity.imagen!
    }
    
    func toEntity(context: NSManagedObjectContext) -> PlatoEntity {
        let platoEntity = PlatoEntity(context: context)
        platoEntity.id = Int32(id)
        platoEntity.nombre = nombre
        platoEntity.precio = Int32(precio)
        platoEntity.imagen = imagen
        return platoEntity;
    }
}
