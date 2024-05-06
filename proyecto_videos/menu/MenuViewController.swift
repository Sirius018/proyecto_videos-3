import UIKit

/*import GoogleSignIn*/
import FirebaseAuth
class MenuViewController: UIViewController {

    @IBOutlet weak var btnCursos: UIButton!
    @IBOutlet weak var btnAlumnos: UIButton!
    @IBOutlet weak var btnMisCursos: UIButton!
    var email:String!
    var provider: String!
    
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblProvider: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmail.text = email
        lblProvider.text = provider
        navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    
    
    
    @IBAction func btnProfesor(_ sender: UIButton) {
        performSegue(withIdentifier: "lkProfesor", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
    @IBAction func btnCerrarSesion(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        
        switch self.provider{
        case "basic":
            firebaseLogOut()
        case "google":
            do {
                /*GIDSignIn.sharedInstance()?.signOut()*/
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
