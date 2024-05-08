//
//  AlumnoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 4/05/24.
//

import UIKit
import Alamofire

class AlumnoViewController:UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tvAlumnos: UITableView!
    var arregloAlumnos:[Alumno] = []
    var bean:Alumno!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarAlumnos()
        tvAlumnos.dataSource = self
        tvAlumnos.delegate = self
        tvAlumnos.rowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloAlumnos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var celda = tvAlumnos.dequeueReusableCell(withIdentifier: "item") as! ItemAlumnoTableViewCell
        celda.imgAlumno.image = UIImage(named: "alumno1")
        celda.lblNombre.text = arregloAlumnos[indexPath.row].nombre + " " + arregloAlumnos[indexPath.row].apellido
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editarAlumno", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminarAlumnoSwipe = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            
            
            let ventana = UIAlertController(title: "Sistema", message: "Seguro de eliminar?", preferredStyle: .alert)
            
            let botonAceptar = UIAlertAction(title: "Si", style: .default) { action in
                // Eliminar el elemento de la lista
                self.mensajeOk(id: self.arregloAlumnos[indexPath.row].id, ms2: " eliminado.")
                self.eliminarAlumno(cod: self.arregloAlumnos[indexPath.row].id)
                // Actualizar la tabla
                tableView.beginUpdates()
                self.arregloAlumnos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            
            ventana.addAction(botonAceptar)
            ventana.addAction(UIAlertAction(title: "No", style: .cancel))
            
            self.present(ventana, animated: true, completion: nil)
            
            completionHandler(true)         
        }
        eliminarAlumnoSwipe.image = UIImage(named: "trash_can")
        return UISwipeActionsConfiguration(actions: [eliminarAlumnoSwipe])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarAlumno" {
            let v2 = segue.destination as! EditarAlumnoViewController
            v2.bean = arregloAlumnos[tvAlumnos.indexPathForSelectedRow!.row]
        } else {
            
        }
    }
	
    @IBAction func btnNuevo(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoAlumno", sender: nil)
    }
    
    @IBAction func regresarCrudAlumno(segue:UIStoryboardSegue!){
        self.cargarAlumnos()
        self.tvAlumnos.reloadData()
        self.dismiss(animated: true)
    }
    
    func cargarAlumnos() {
        AF.request("https://api-moviles-2.onrender.com/alumnos").responseDecodable(of: [Alumno].self) { data  in
            guard let info = data.value else { return }
            self.arregloAlumnos = info
            self.tvAlumnos.reloadData()
        }
    };
    
    func eliminarAlumno(cod:Int) {
        AF.request("https://api-moviles-2.onrender.com/" + String(cod), method: .delete).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                print("Alumno eliminado")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    func mensajeOk(id:Int, ms2:String) {
        let alertController = UIAlertController(title: "Sistema", message: "Alumno con id: " + String(id) + ms2, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}
	
