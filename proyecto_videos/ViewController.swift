
import UIKit
import Alamofire
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    @IBOutlet weak var btnGoogle: UIButton!
    var listaUsuarios: [Usuario] = [] // Lista de tipo Alumno
    var provider = ""
    let defaults = UserDefaults.standard
    var usuarioLogueado:[String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Analytics Event
        
        txtClave.isSecureTextEntry = true
        obtenerUsuarios()

        if let sesion = defaults.value(forKey: "sesion") as? [String: Any],
           let email = sesion["email"] as? String,
           let provider = sesion["provider"] as? String,
           !email.isEmpty, !provider.isEmpty {
           print(email)
           print("El proveedor es " + provider)
           //self.navigationController?.popViewController(animated: true)
           self.performSegue(withIdentifier: "menu", sender: self)
        }

    }
    
    @IBAction func btnRegistrarse(_ sender: UIButton) {
        performSegue(withIdentifier: "crearUsuario", sender: nil)
    }
    @IBAction func btnIniciar(_ sender: UIButton) {
       
        if let email=txtUsuario.text, let password = txtClave.text{
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil{
                    self.provider = "basic"
                    var email = self.txtUsuario.text ?? ""
                    var provider = self.provider
                    
                    self.buscarUsuarioPorEmail(email: email) { usuario, error in
                        if let error = error {
                            print("Error al buscar usuario: \(error)")
                            return
                        }
                        
                        if let usuario_nuevo = usuario {
                            // Aquí puedes hacer lo que necesites con el usuario encontrado
                            print("Usuario encontrado: \(usuario_nuevo)")
                            self.usuarioLogueado = ["email":email, "nombre":usuario_nuevo.nombre, "apellido":usuario_nuevo.apellido, "rol":usuario_nuevo.rol, "provider": "basic"]
                            self.defaults.set(self.usuarioLogueado, forKey: "sesion")
                            self.defaults.synchronize()
                            self.performSegue(withIdentifier: "menu", sender: nil)
                        }
                    }
                    
                    self.defaults.synchronize()
                    print("Usuario logeado guardado con exito")
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
                      let email = authResult!.user.email ?? ""
                      let nombre = authResult!.user.displayName ?? ""
                  self.usuarioLogueado = ["email":email, "nombre":nombre, "apellido":"", "rol":"Alumno", "provider": "google"]
                  self.buscarUsuarioPorEmail(email: email) { usuario, error in
                      if let error = error {
                          self.creaUsuario(id: 0, nombre: nombre, apellido: "", rol:"Alumno",email: email, password: "123456")
                         
                      }
                      if let usuario_nuevo = usuario {
                          // Aquí puedes hacer lo que necesites con el usuario encontrado
                          print("Usuario encontrado: \(usuario_nuevo)")
                          self.usuarioLogueado = ["email":email, "nombre":usuario_nuevo.nombre, "apellido":usuario_nuevo.apellido, "rol":usuario_nuevo.rol, "provider": "google"]
                      }
                  }

                  self.defaults.set(self.usuarioLogueado, forKey: "sesion")
                  self.defaults.synchronize()
                      
                     
                      print("Email del usuario: \(email)")
                      print("Nombre del usuario: \(nombre)")
                // El usuario ha iniciado sesión correctamente, puedes acceder a authResult.user para obtener información del usuario
                print("Usuario autenticado con Firebase: \(authResult!.user.uid)")
                  self.performSegue(withIdentifier: "menu", sender: nil)
              }
        }
    
        
    }
    func creaUsuario(id:Int, nombre:String, apellido:String,rol:String, email:String, password:String){
        let parametros: [String: Any] = [
                                "id": id,
                                "nombre": nombre,
                                "apellido":apellido,
                                "rol":rol,
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="menu" {
            //self.defaults.set(self.usuarioLogueado, forKey: "sesion")
            //self.defaults.synchronize()
            
               }
    }
    func obtenerUsuarioEmail(email:String) -> Usuario?{
        // Busca el usuario con el correo y contraseña proporcionados
        var usuario = self.listaUsuarios.first(where: { $0.email == email})
            // Usuario encontrado, puedes iniciar sesión aquí
        return usuario
       
    }
    
    
    func obtenerUsuarios() {
            // URL del API
            let url = "https://api-moviles-2.onrender.com/usuarios"
            
            // Realizar la solicitud Alamofire para obtener los usuarios
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Usuario].self) { response in
                    switch response.result {
                    case .success(let usuarios):
                        // Almacenar los alumnos en la lista
                        self.listaUsuarios = usuarios
                        // Aquí puedes manejar los datos de los alumnos si es necesario
                        for usuario in self.listaUsuarios {
                            print("ID: \(usuario.id), Nombre: \(usuario.nombre), Apellido: \(usuario.apellido), email \(usuario.email)")
                        }
                    case .failure(let error):
                        // Manejar el error en caso de que falle la solicitud
                        print("Error al obtener usuarios: \(error)")
                    }
            }
        }
    
    func verificarCredenciales(usuario: String, contraseña: String) -> Bool {
            // Verificar si existe algún alumno con las credenciales ingresadas
            for alumno in listaUsuarios {
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
    
    func buscarUsuarioPorEmail(email: String, completionHandler: @escaping (Usuario?, Error?) -> Void) {
        // URL de la API y endpoint para buscar usuarios por email
        let urlString = "https://api-moviles-2.onrender.com/usuarios/\(email)"
        
        // Configurar los parámetros de la solicitud POST si es necesario
        let parameters: [String: Any] = [
            "email": email
            // Aquí puedes agregar más parámetros si es necesario
        ]
        
        // Realizar la solicitud con Alamofire
        AF.request(urlString, method: .post, parameters: parameters).validate().responseDecodable(of: Usuario.self) { response in
            switch response.result {
            case .success(let usuario):
                completionHandler(usuario, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }

}

