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
        
        var ventana = UIAlertController(title: "Sistema", message: "¿Seguro de actualizar?", preferredStyle: .alert)
        var botonSI = UIAlertAction(title: "SI", style: .default, handler: { action in self.actualizarProfesor(bean: self.bean)
            if let viewController = self.presentingViewController as? ProfesorViewController {
                viewController.cargarProfesores()
                viewController.tvProfe.reloadData()
                self.dismiss(animated: true)
            }
        })
        ventana.addAction(botonSI)
        ventana.addAction(UIAlertAction(title: "NO", style: .cancel))
        self.present(ventana, animated: true, completion: nil)
          
        
    }
    
    @IBAction func btnEliminar(_ sender: UIButton) {
        var ventana = UIAlertController(title: "Sistema", message: "¿Seguro de eliminar?", preferredStyle: .alert)
        var botonSI = UIAlertAction(title: "SI", style: .default, handler: { action in
            self.eliminarProfesor(cod: self.bean.id)
            if let viewController = self.presentingViewController as? ProfesorViewController {
                viewController.cargarProfesores()
                viewController.tvProfe.reloadData()
                self.dismiss(animated: true)
            }
        })
        ventana.addAction(botonSI)
        ventana.addAction(UIAlertAction(title: "NO", style: .cancel))
        self.present(ventana, animated: true, completion: nil)
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
                            self.mensajeOk(id: bean.id, ms2: " actualizado.")
                                print(" Profesor actualizado")
                        } catch {
                            print("Error en el JSON")
                        }
                    case.failure(let error):
                        print(error.localizedDescription)
                }
            
        })
    }
    
    func eliminarProfesor(cod:String) {
        AF.request("https://api-moviles-2.onrender.com/" + cod, method: .delete).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                self.mensajeOk(id: cod, ms2: " eliminado.")
                print("Profesor eliminado")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
   
    func mensajeOk(id:String, ms2:String) {
        let alertController = UIAlertController(title: "Sistema", message: "Profesor con id: " + self.bean.id + ms2, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.performSegue(withIdentifier: "regresarCrudProfesor", sender: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}
