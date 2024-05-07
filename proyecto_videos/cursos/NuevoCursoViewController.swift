//


import UIKit
import Alamofire
import DropDown
class NuevoCursoViewController: UIViewController {

    let dropDown = DropDown()
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtDescripcion: UITextField!
    
    @IBOutlet weak var txtPrecio: UITextField!
    
    @IBOutlet weak var txtCaracteristicas: UITextField!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnRegistrar(_ sender: UIButton) {
        
        
            let nombre = txtNombre.text ?? ""
            let caracteristicas = txtCaracteristicas.text ?? ""
            let descripcion = txtDescripcion.text ?? ""
            let precio = Double(txtPrecio.text ?? "0") ?? 0
            let categoria =  dropDown.selectedItem ?? ""

            // Crear el objeto curso
        let curso = Cursos(id: 0, nombre: nombre,  descripcion: descripcion,caracteristicas: caracteristicas, categoria: categoria, estado: "Creado", idProfesor: 35, precio: precio)


        grabarCurso(bean: curso)
        self.performSegue(withIdentifier: "regresarCrudCurso", sender: nil)
    }
    

    
    @IBAction func btnCategoria(_ sender: UIButton) {
        
        dropDown.anchorView = sender
        dropDown.dataSource = ["Informatica", "Disenio Grafico", "Redes","Marketing"]
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item:String) in
            sender.setTitle(item, for: .normal)
            
            
        }
    }
    
    
    func grabarCurso(bean: Cursos) {
        AF.request("https://api-moviles-2.onrender.com/cursos", method: .post, parameters: bean, encoder: JSONParameterEncoder.default).response(completionHandler: { response in
            switch response.result {
            case .success(let data):
                do {
                    let curso = try JSONDecoder().decode(Cursos.self, from: data!)
                    print("Curso agregado: \(curso.nombre), ID: \(curso.id)")
                } catch {
                    print("Error decoding JSON:", error)
                }
            case .failure(let error):
                print("Request failed with error:", error.localizedDescription)
            }
        })
    }

    
}

