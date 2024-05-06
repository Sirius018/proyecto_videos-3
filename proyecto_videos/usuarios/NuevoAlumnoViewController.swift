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
        let bean = Alumno(id: 0, nombre: nom, apellido: ape, rol: "Alumno", email: cor, password: cla)
        grabarAlumno(bean: bean)
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
