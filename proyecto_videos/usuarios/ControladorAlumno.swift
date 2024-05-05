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
        var tabla = AlumnoEntity(context: contextoDB)
        tabla.id = Int16(bean.id)
        tabla.nombre = bean.nombre
        tabla.apellido = bean.apellido
        tabla.rol = bean.rol
        tabla.email = bean.email
        tabla.password = bean.password
        do {
            try contextoDB.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func find(bean:Alumno)->[AlumnoEntity] {
        var alumno:[AlumnoEntity]!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoDB = delegate.persistentContainer.viewContext
        do {
            let registro = AlumnoEntity.fetchRequest()
            registro.predicate = NSPredicate(format: "email == %@", bean.email)
            registro.predicate = NSPredicate(format: "password == %@", bean.password)
            try alumno = contextoDB.fetch(registro)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return alumno
    }
    func findAll()->[AlumnoEntity] {
        var datos:[AlumnoEntity]!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contenxtoDB = delegate.persistentContainer.viewContext
        do {
            let registros = AlumnoEntity.fetchRequest()
            try datos = contenxtoDB.fetch(registros)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return datos
    }
    func updateAlumno(bean:AlumnoEntity) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoDB = delegate .persistentContainer.viewContext
        do {
            try contextoDB.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func deleteAlumno(bean:AlumnoEntity) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contextoDB = delegate.persistentContainer.viewContext
        do {
            contextoDB.delete(bean)
            try contextoDB.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

