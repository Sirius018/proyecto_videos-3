//
//  AlumnoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 4/05/24.
//

import UIKit

class AlumnoViewController:UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tvAlumnos: UITableView!
    var arregloAlumnos:[Alumno] = []
    var bean:Alumno!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloAlumnos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var celda = tvAlumnos.dequeueReusableCell(withIdentifier: "item") as! ItemAlumnoTableViewCell
        celda.lblNombre.text = "Nombre: " + arregloAlumnos[indexPath.row].nombre
        celda.lblApellido.text = "Apellido: " + arregloAlumnos[indexPath.row].apellido
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editarAlumno", sender: nil)
    }
	
    @IBAction func btnNuevo(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoAlumno", sender: nil)
    }
    
}
	
