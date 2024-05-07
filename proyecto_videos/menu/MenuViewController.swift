import UIKit

import GoogleSignIn
import FirebaseAuth
class MenuViewController: UIViewController {

    @IBOutlet weak var btnCursos: UIButton!
    @IBOutlet weak var btnMisCursos: UIButton!
    var email:String!
    var provider: String!
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblProvider: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaults.synchronize()
        if let sesion = self.defaults.value(forKey: "sesion") as? [String: Any] {
            if let email = sesion["email"] as? String,
               let provider = sesion["provider"] as? String,
               let rol = sesion["rol"] as? String {
                lblEmail.text = email
                lblProvider.text = provider
                if rol != "Alumno" {
                             //   btnCursos.isHidden = true
                                btnMisCursos.isHidden = true
                }
                print("Sesión guardada:")
                print("Email: \(email)")
                print("Provider: \(provider)")
                print("Rol: \(rol)")
            }
        }
        navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    @IBAction func btnVerCursosAddEventListener(_ sender: UIButton) {
        performSegue(withIdentifier: "showVerCursos", sender: nil)
    }
    
    @IBAction func btnMisCursos(_ sender: UIButton) {
        
        performSegue(withIdentifier: "verMisCursos", sender: nil)
    }
    
    
    @IBAction func btnProfesor(_ sender: UIButton) {
        performSegue(withIdentifier: "lkProfesor", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerCursos" {
               // Asegúrate de que el destino del segue sea tu VerCursosViewController
               if let verCursosVC = segue.destination as? VerCursosViewController {
                   
               }
           }
    }
    @IBAction func regresarMenuPerfil(segue:UIStoryboardSegue!){
        
        //dismiss(animated: true)
    }
    
    
    @IBAction func btnCerrarSesion(_ sender: UIButton) {
        
        self.defaults.removeObject(forKey: "sesion")
        self.defaults.synchronize()
        
        
        switch self.provider{
        case "basic":
            firebaseLogOut()
        case "google":
            do {
                GIDSignIn.sharedInstance.signOut()
                firebaseLogOut()
            }
            
        default:
            print("Hola")
        }
        
    }
    private func firebaseLogOut(){
        do {
            try Auth.auth().signOut()
        }
        catch{
            
        }
    }
    
}
