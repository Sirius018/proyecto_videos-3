
import UIKit
import Alamofire
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
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
            print(email)
            print("el proveedor es" + provider)
            //self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "menu", sender: self)
        }

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
                    var email = self.txtUsuario.text ?? ""
                    var provider = self.provider
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: "email")
                    defaults.set(provider, forKey: "provider")
                    defaults.synchronize()
                    print("hola")
                    self.performSegue(withIdentifier: "menu", sender: nil)
                } else {
                    self.mostrarAlerta(mensaje: "Se ha producido un error")
                }
            }
        }
        
        
    }
    
    @IBAction func btnGoogleAccion(_ sender: UIButton) {
       GIDSignIn.sharedInstance.signOut()
        /*GIDSignIn.sharedInstance()?.signIn()*/
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Error al iniciar sesión con Google: \(error!.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("Error: No se pudo obtener el token de ID del usuario.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // Use the credential to sign in with Firebase Authentication
              Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                  print("Error al autenticar con Firebase: \(error.localizedDescription)")
                  return
                }
                  // El usuario ha iniciado sesión correctamente, puedes acceder a authResult.user para obtener información del usuario
                      let userID = authResult!.user.uid
                      let userEmail = authResult!.user.email ?? ""
                      let userName = authResult!.user.displayName ?? ""
                      
                      // Guardar la información en UserDefaults
                      let defaults = UserDefaults.standard
                      defaults.set(userID, forKey: "userID")
                      defaults.set(userEmail, forKey: "userEmail")
                      defaults.set(userName, forKey: "userName")
                      
                      print("Usuario autenticado con Firebase: \(userID)")
                      print("Email del usuario: \(userEmail)")
                      print("Nombre del usuario: \(userName)")
                // El usuario ha iniciado sesión correctamente, puedes acceder a authResult.user para obtener información del usuario
                print("Usuario autenticado con Firebase: \(authResult!.user.uid)")
                  self.performSegue(withIdentifier: "menu", sender: nil)
              }
        }
    
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="menu" {
            //let p2 = segue.destination as! MenuViewController
            //p2.provider = self.provider
            
               }
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
}

