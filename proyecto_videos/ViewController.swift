
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtClave.isSecureTextEntry = true 
    }


    @IBAction func btnIniciar(_ sender: UIButton) {
        if txtUsuario.text?.isEmpty ?? true || txtClave.text?.isEmpty ?? true {
                // alerta para ingresar datos
                mostrarAlerta(mensaje: "Por favor ingrese usuario y clave")
            } else {
                // todo ok
                performSegue(withIdentifier: "menu", sender: nil)
            }
        
        
    }
    
    
    
    
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
}

