//
//  NuevoAlumnoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 4/05/24.
//

import UIKit

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
        let alu = Alumno(id: 0, nombre: nom, apellido: ape, rol: cor, email: cor, password: cla)
        ControladorAlumno().saveAlumno(bean: alu)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
