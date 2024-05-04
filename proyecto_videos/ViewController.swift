
import UIKit
import Alamofire
import FirebaseCore
import FirebaseAuth
//import GoogleSignIn
class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    @IBOutlet weak var btnGoogle: UIButton!
    var listaAlumnos: [Alumno] = [] // Lista de tipo Alumno
    var provider = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        
        txtClave.isSecureTextEntry = true
        //obtenerUsuarios()
        let defaults = UserDefaults.standard

       
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String,
           !email.isEmpty, !provider.isEmpty {
            print("Hola")
            ///self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "menu", sender: nil)
        }
/*
        // Google auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self*/
        
        
        
        
         /*        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String{
            print("Hola")
            self.performSegue(withIdentifier: "menu", sender: nil)
            self.dismiss(animated: true, completion: nil)        }*/
    }
    
    @IBAction func btnRegistrarse(_ sender: UIButton) {
        performSegue(withIdentifier: "crearUsuario", sender: nil)
    }
    @IBAction func btnIniciar(_ sender: UIButton) {
        /*
        if txtUsuario.text?.isEmpty ?? true || txtClave.text?.isEmpty ?? true {
                    // alerta para ingresar datos
                    mostrarAlerta(mensaje: "Por favor ingrese usuario y clave")
                } else {
                    // Verificar las credenciales ingresadas
                    if verificarCredenciales(usuario: txtUsuario.text!, contraseña: txtClave.text!) {
                        // Credenciales correctas, proceder a la siguiente pantalla
                        performSegue(withIdentifier: "menu", sender: nil)
                    } else {
                        // Credenciales incorrectas, mostrar alerta
                        mostrarAlerta(mensaje: "Inicio de sesión incorrecto")
                    }
                }
        */
        if let email=txtUsuario.text, let password = txtClave.text{
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil{
                    self.provider = "basic"
                    self.performSegue(withIdentifier: "menu", sender: nil)
                } else {
                    self.mostrarAlerta(mensaje: "Se ha producido un error")
                }
            }
        }
        
        
    }
    
    @IBAction func btnGoogleAccion(_ sender: UIButton) {
       /* GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()*/
        
        
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="menu" {
            let p2 = segue.destination as! MenuViewController
            p2.provider = self.provider
            
            var email_x = txtUsuario.text ?? ""
            p2.email = email_x
            let defaults = UserDefaults.standard
            defaults.set(email_x, forKey: "email")
            defaults.set(provider, forKey: "provider")
            defaults.synchronize()        }
    }
    func obtenerUsuarios() {
            // URL del API
            let url = "https://api-moviles-2.onrender.com/usuarios"
            
            // Realizar la solicitud Alamofire para obtener los usuarios
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Alumno].self) { response in
                    switch response.result {
                    case .success(let alumnos):
                        // Almacenar los alumnos en la lista
                        self.listaAlumnos = alumnos
                        // Aquí puedes manejar los datos de los alumnos si es necesario
                        for alumno in self.listaAlumnos {
                            print("ID: \(alumno.id), Nombre: \(alumno.nombre), Apellido: \(alumno.apellido), Password \(alumno.password)")
                        }
                    case .failure(let error):
                        // Manejar el error en caso de que falle la solicitud
                        print("Error al obtener usuarios: \(error)")
                    }
            }
        }
    
    func verificarCredenciales(usuario: String, contraseña: String) -> Bool {
            // Verificar si existe algún alumno con las credenciales ingresadas
            for alumno in listaAlumnos {
                if alumno.email == usuario && alumno.password == contraseña {
                    return true // Credenciales correctas
                }
            }
            return false // Credenciales incorrectas
        }
            
    func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    @IBAction func regresar(segue:UIStoryboardSegue!){
        
    }
    private func showHome(result: AuthDataResult?, error:Error?, provider: String){
        
                if let result = result, error == nil{
                    self.provider = provider
                    self.performSegue(withIdentifier: "menu", sender: nil)
                } else {
                    self.mostrarAlerta(mensaje: "Se ha producido un error")
                }
    }
}/*
extension ViewController:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential){
                (result, error) in
                self.showHome(result:result, error: error, provider: "google")
            }
            }
        }
}*/

