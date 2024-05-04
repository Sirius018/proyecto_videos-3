//
//  RegistrarseViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 3/05/24.
//

import UIKit
import FirebaseAuth
import Alamofire
class RegistrarseViewController: UIViewController {
    
    @IBOutlet weak var txtApellidoUsuario: UITextField!
    @IBOutlet weak var txtNombreUsuario: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        if let email=txtEmail.text, let password = txtPassword.text{
            
            var nombreUsuario = txtNombreUsuario.text ?? ""
            var apellidoUsuario = txtApellidoUsuario.text ?? ""
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil{
                    self.creaUsuario(id: 0, nombre: nombreUsuario, apellido: apellidoUsuario, email: email, password: password)
                    
                    self.performSegue(withIdentifier: "regresarSesion", sender: nil)
                } else {
                    self.mostrarAlerta(mensaje: "Se ha producido un error")
                }
            }
        }
    }
    func creaUsuario(id:Int, nombre:String, apellido:String, email:String, password:String){
        let parametros: [String: Any] = [
                                "id": id,
                                "nombre": nombre,
                                "apellido":apellido,
                                "rol":"Alumno",
                                "email":email,
                                "password":password
                            ]

                            AF.request("https://api-moviles-2.onrender.com/usuarios", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil)
                                .validate()
                                .responseJSON { response in
                                    switch response.result {
                                    case .success:
                                        print("Registro exitoso")
                                        self.mostrarAlerta(mensaje: "Registro Exitoso" )
                                        
                                    case .failure(let error):
                                        print("Error al registrar: \(error)")
                                    }
                                }
    }
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
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
