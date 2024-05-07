
import UIKit
import Alamofire

class ProfesorViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tvProfe: UITableView!
    
    var arregloProfesores:[Profesor]=[]
    var bean:Profesor!

    override func viewDidLoad() {
        super.viewDidLoad()
        cargarProfesores()
        tvProfe.dataSource=self
        tvProfe.delegate = self
        tvProfe.rowHeight=120
        

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloProfesores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let v2=tvProfe.dequeueReusableCell(withIdentifier: "itemProfesor2") as! ItemmProfesorTableViewCell
        v2.imgProfesor.image = UIImage(named: "profesor1")
        v2.lblIdProfe .text=String(arregloProfesores[indexPath.row].id)
        v2.lblNombreProfe.text=arregloProfesores[indexPath.row].nombre
        return v2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editarProfesor", sender: nil)

    }
    
    
  
   
  
    
    func cargarProfesores() {
        AF.request("https://api-moviles-2.onrender.com/profesores")
            .responseDecodable(of: [Profesor].self) { response in
                switch response.result {
                case .success(let profesores):
                    // Imprimir los registros en la consola
                    print("Registros de profesores:")
                    for profesor in profesores {
                        print(profesor)
                    }
                    
                    // Actualizar la variable de instancia y recargar la tabla
                    self.arregloProfesores = profesores
                    self.tvProfe.reloadData()
                    
                case .failure(let error):
                    print("Error al cargar los profesores: \(error)")
                }
            }
    }

    
  
    
    @IBAction func btnNuevoProfesor(_ sender: UIButton) {
        performSegue(withIdentifier: "lkNuevoProfesor", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lkNuevoProfesor"{
            let pantallaP=segue.destination as! NuevoProfesorViewController
        }else if segue.identifier == "editarProfesor"{
            let v2 = segue.destination as! ActualizarProfesorViewController
            v2.bean = arregloProfesores[tvProfe.indexPathForSelectedRow!.row]
        }
        
    }
}
