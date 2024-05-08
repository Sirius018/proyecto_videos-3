
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
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eliminarProfesorSwipe = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            
            
            let ventana = UIAlertController(title: "Sistema", message: "Seguro de eliminar?", preferredStyle: .alert)
            
            let botonAceptar = UIAlertAction(title: "Si", style: .default) { action in
                // Eliminar el elemento de la lista
                self.mensajeOk(id: self.arregloProfesores[indexPath.row].id, ms2: " eliminado.")
                self.eliminarProfesor(cod: self.arregloProfesores[indexPath.row].id)
                // Actualizar la tabla
                tableView.beginUpdates()
                self.arregloProfesores.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            
            ventana.addAction(botonAceptar)
            ventana.addAction(UIAlertAction(title: "No", style: .cancel))
            
            self.present(ventana, animated: true, completion: nil)
            
            completionHandler(true)
        }
        eliminarProfesorSwipe.image = UIImage(named: "trash_can")
        return UISwipeActionsConfiguration(actions: [eliminarProfesorSwipe])
    }
    
    @IBAction func regresarCrudProfesor(segue:UIStoryboardSegue!){
        self.cargarProfesores()
        self.tvProfe.reloadData()
        //dismiss(animated: true)
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
    
    func eliminarProfesor(cod:Int) {
        AF.request("https://api-moviles-2.onrender.com/" + String(cod), method: .delete).response(completionHandler: { info in
            switch info.result {
            case .success(let data):
                print("Profesor eliminado")
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    
    func mensajeOk(id:Int, ms2:String) {
        let alertController = UIAlertController(title: "Sistema", message: "Profesor con id: " + String(id) + ms2, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}
