
import UIKit
import Alamofire

class NuevoProfesorViewController: UIViewController {

    @IBOutlet weak var txtIdProfesor: UITextField!
    @IBOutlet weak var txtNombreProfesor: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        guard let idP = Int16(txtIdProfesor.text ?? "0"), let nombreP = txtNombreProfesor.text else {
            mostrarAlertaError(mensaje: "Por favor, completa todos los campos.")
            return
        }

        if nombreP.isEmpty {
            mostrarAlertaError(mensaje: "Por favor, ingresa nombre del profesor.")
        } else {
            obtenerListaProfesores { profesores in
                guard let profesores = profesores else {
                    print("No se pudo obtener la lista de profesores.")
                    return
                }
                
                let idExistente = profesores.contains { $0.idProfesor == idP }
                let nombreExistente = profesores.contains { $0.nombreProfesor == nombreP }
                // valida que profesor no exista
                if idExistente {
                    self.mostrarAlertaError(mensaje: "El ID ya está en uso")
                } else if nombreExistente {
                    self.mostrarAlertaError(mensaje: "El nombre del profesor ya existe, usar otro")
                } else {
                    
                    let parametros: [String: Any] = [
                        "idProfesor": idP,
                        "nombreProfesor": nombreP
                    ]

                    AF.request("https://api-moviles-2.onrender.com/profesores", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil)
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success:
                                print("Registro exitoso")
                                self.mostrarMensajeExito()
                                
                            case .failure(let error):
                                print("Error al registrar: \(error)")
                            }
                        }
                }
            }
        }
    }
    
    
    
    
    func mostrarAlertaError(mensaje: String) {
        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
    func mostrarMensajeExito() {
        let alertController = UIAlertController(title: "Éxito", message: "Se ha registrado correctamente el profesor.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func obtenerListaProfesores(completion: @escaping ([Profesor]?) -> Void) {
        AF.request("https://api-moviles-2.onrender.com/profesores")
            .responseDecodable(of: [Profesor].self) { response in
                guard let profesores = response.value else {
                    completion(nil)
                    return
                }
                completion(profesores)
            }
    }
    
    
    
    
    @IBAction func btnVolver(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("ProfesorGuardado"), object: nil)
        dismiss(animated: true)
    }
    
    
}
