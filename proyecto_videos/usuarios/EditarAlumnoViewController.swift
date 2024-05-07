//
//  EditarAlumnoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 6/05/24.
//

import UIKit
import Alamofire

class EditarAlumnoViewController: UIViewController {
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    
    var bean:Alumno!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtNombre.text = bean.nombre
        txtApellido.text = bean.apellido
        txtCorreo.text = bean.email
    }

    @IBAction func btnActualizar(_ sender: UIButton) {
        let nom = txtNombre.text ?? ""
        let ape = txtApellido.text ?? ""
        let cor = txtCorreo.text ?? ""
        bean.nombre = nom
        bean.apellido = ape
        bean.email = cor
        actualizarAlumno(bean: bean)
    }
    
    @IBAction func btnEliminar(_ sender: UIButton) {
        var ventana = UIAlertController(title: "Sistema", message: "¿Seguro de eliminar?", preferredStyle: .alert)
        var botonSI = UIAlertAction(title: "SI", style: .default, handler: { action in
            self.eliminarAlumno(cod: self.bean.id)
            self.bean.id = 0
            self.bean.nombre = ""
            self.bean.apellido = ""
            self.bean.email = ""
            self.bean.password = ""
            self.txtNombre.text = self.bean.nombre
            self.txtApellido.text = self.bean.apellido
            self.txtCorreo.text = self.bean.email
            self.performSegue(withIdentifier: "regresarCrudAlumno", sender: nil)
        })
        ventana.addAction(botonSI)
        ventana.addAction(UIAlertAction(title: "NO", style: .cancel))
        self.present(ventana, animated: true, completion: nil)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        if let viewController = presentingViewController as? AlumnoViewController {
            viewController.cargarAlumnos()
            viewController.tvAlumnos.reloadData()
            dismiss(animated: true)
        }
    }
    
    func actualizarAlumno(bean:Alumno) {
        AF.request("https://api-moviles-2.onrender.com/alumnos/" + String(bean.id), method: .put, parameters: bean, encoder: JSONParameterEncoder.default).response(completionHandler: { info in
                switch info.result {
                    case.success(let data):
                        do {
                            let row = try JSONDecoder().decode(Alumno.self, from: data!)
                                print("Alumno actualizado")
                        } catch {
                            print("Error en el JSON")
                        }
                    case.failure(let error):
                        print(error.localizedDescription)
                }
            
        })
    }
    
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
    
}
