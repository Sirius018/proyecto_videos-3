//
//  ActualizarProfesorViewController.swift
//  proyecto_videos
//
//  Created by DAMII on 6/05/24.
//

import UIKit
import Alamofire
class ActualizarProfesorViewController: UIViewController {
    var bean:Profesor!

    
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtApellido: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNombre.text = bean.nombre
        txtApellido.text = bean.apellido
        txtEmail.text = bean.email
        
    }
    

    @IBAction func btnModificar(_ sender: UIButton) {
        let nom = txtNombre.text ?? ""
        let ape = txtApellido.text ?? ""
        let email = txtEmail.text ?? ""

        bean.nombre = nom
        bean.apellido = ape
        bean.email = email
        
        actualizarProfesor(bean: bean)
          
        
    }
    
    @IBAction func btnEliminar(_ sender: UIButton) {/*
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
        self.present(ventana, animated: true, completion: nil)*/
    }
    
    @IBAction func btnVolver(_ sender: Any) {
        dismiss(animated: true)

    }
    
    func actualizarProfesor(bean:Profesor) {
        AF.request("https://api-moviles-2.onrender.com/profesores/" + String(bean.id), method: .put, parameters: bean, encoder: JSONParameterEncoder.default).response(completionHandler: { info in
                switch info.result {
                    case.success(let data):
                        do {
                            let row = try JSONDecoder().decode(Profesor.self, from: data!)
                                print(" Profesor actualizado")
                        } catch {
                            print("Error en el JSON")
                        }
                    case.failure(let error):
                        print(error.localizedDescription)
                }
            
        })
    }
    
    func eliminarProfesor(cod:Int) {
        AF.request("https://api-moviles-2.onrender.com/" + String(cod), method: .delete).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                print("Profesor eliminado")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
   
    
    
}
