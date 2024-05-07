
import UIKit
import Alamofire

class NuevoProfesorViewController: UIViewController {

    var listaProfesores:[Profesor]=[]

    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtApellido: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        
        let nombre = txtNombre.text ?? ""
        let apellidos = txtApellido.text ?? ""
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        
        let profesor = Profesor(id: 0, nombre: nombre, apellido: apellidos, rol: "Profesor", email: email, password: password)
        
        grabarProfesor(bean: profesor)
        
        
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
    
    func cargarProfesores(){
            AF.request("https://api-moviles-2.onrender.com/profesores")
                .responseDecodable(of: [Profesor].self){ x in
                    guard let info=x.value else {return}
                    self.listaProfesores=info
                    print(info)
                }
    }
 
    func grabarProfesor(bean: Profesor) {
        AF.request("https://api-moviles-2.onrender.com/profesores", method: .post, parameters: bean, encoder: JSONParameterEncoder.default).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                do {
                    let row = try JSONDecoder().decode(Profesor.self, from: data!)
                    print("Profesor agregado " + String(row.id))
                } catch {
                    print("Error en el JSON")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

    
    
    
    @IBAction func btnVolver(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("ProfesorGuardado"), object: nil)
        dismiss(animated: true)
    }
    
    
}
