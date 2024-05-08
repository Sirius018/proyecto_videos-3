//
//  CambioContrasenaViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 8/05/24.
//

import UIKit
import FirebaseAuth
class CambioContrasenaViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var txtContrasenaAntigua: UITextField!
    
    
    @IBOutlet weak var txtContrasenaNueva: UITextField!
    
    @IBOutlet weak var txtContrasenaNuevaRepeticion: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let sesion = self.defaults.value(forKey: "sesion") as? [String: Any] {
            if let email = sesion["email"] as? String,
               let provider = sesion["provider"] as? String,
               let rol = sesion["rol"] as? String {
               
                }
                print("Sesión guardada:")
        }
    }
    

    @IBAction func btnCambiarContrasena(_ sender: UIButton) {
        guard let contrasenaAntigua = txtContrasenaAntigua.text,
              !contrasenaAntigua.isEmpty,
              let contrasenaNueva = txtContrasenaNueva.text,
              !contrasenaNueva.isEmpty,
              let contrasenaNuevaRepeticion = txtContrasenaNuevaRepeticion.text,
              !contrasenaNuevaRepeticion.isEmpty
        else {
            print("Por favor, complete todos los campos.")
            return
        }
                
                // Verificar que las contraseñas nuevas coincidan
                guard contrasenaNueva == contrasenaNuevaRepeticion else {
                    print("Las contraseñas nuevas no coinciden.")
                    return
                }
                
                // Obtener el usuario actualmente autenticado
                guard let user = Auth.auth().currentUser else {
                    print("No se ha iniciado sesión.")
                    return
                }
                
                // Crear credencial de reautenticación
                let credential = EmailAuthProvider.credential(withEmail: user.email!, password: contrasenaAntigua)
                
                // Reautenticar al usuario
                user.reauthenticate(with: credential) { authResult, error in
                    if let error = error {
                        print("Contraseña actual incorrecta:", error.localizedDescription)
                        return
                    }
                    
                    // Cambiar la contraseña del usuario
                    user.updatePassword(to: contrasenaNueva) { error in
                        if let error = error {
                            print("Error al cambiar la contraseña:", error.localizedDescription)
                            return
                        }
                        
                        print("Contraseña cambiada exitosamente.")
                        self.performSegue(withIdentifier: "regresarMenuPerfil", sender: nil)
                    }
                }
            }
    
}
