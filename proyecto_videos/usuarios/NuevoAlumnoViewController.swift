//
//  NuevoAlumnoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 4/05/24.
//

import UIKit
import Alamofire

class NuevoAlumnoViewController: UIViewController {
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        let nom, ape, cor, cla:String
        nom = txtNombre.text ?? ""
        ape = txtApellido.text ?? ""
        cor = txtCorreo.text ?? ""
        cla = txtClave.text ?? ""
        let ventana = UIAlertController(title: "Sistema", message: "Seguro de registrar?", preferredStyle: .alert)
        
        let botonAceptar = UIAlertAction(title: "Si", style: .default) { action in
            let bean = Alumno(id: 0, nombre: nom, apellido: ape, rol: "Alumno", email: cor, password: cla)
            self.grabarAlumno(bean: bean)
            if let viewController = self.presentingViewController as? AlumnoViewController {
                viewController.cargarAlumnos()
                viewController.tvAlumnos.reloadData()
                self.dismiss(animated: true)
            }
        }
        
        ventana.addAction(botonAceptar)
        ventana.addAction(UIAlertAction(title: "No", style: .cancel))
        
        self.present(ventana, animated: true, completion: nil)
        
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        if let viewController = presentingViewController as? AlumnoViewController {
            viewController.cargarAlumnos()
            viewController.tvAlumnos.reloadData()
            dismiss(animated: true)
        }
    }
    
    func grabarAlumno(bean: Alumno) {
        AF.request("https://api-moviles-2.onrender.com/alumnos", method: .post, parameters: bean, encoder: JSONParameterEncoder.default).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                do {
                    let row = try JSONDecoder().decode(Alumno.self, from: data!)
                    let alertController = UIAlertController(title: "Sistema", message: "Alumno con id: " + String(row.id) + " agregado.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "regresarCrudAlumno", sender: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                    print("Alumno agregado " + String(row.id))
                } catch {
                    print("Error en el JSON")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
