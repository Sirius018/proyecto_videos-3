//
//  ControladorAlumno.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 1/05/24.
//

import UIKit

class ControladorAlumno {
    func saveAlumno(bean:Alumno) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoDB = delegate.persistentContainer.viewContext
        var tabla = Entity(context: contextoDB)
    }}
