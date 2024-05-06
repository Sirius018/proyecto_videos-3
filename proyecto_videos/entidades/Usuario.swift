//
//  Usuario.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 5/05/24.
//

import UIKit

struct Usuario:Codable {
    var id:Int
    var nombre:String
    var apellido:String
    var rol:String
    var email:String
    var password:String
}
