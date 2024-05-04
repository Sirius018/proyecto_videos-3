
import UIKit
import Alamofire

class ProfesorViewController: UIViewController , UITableViewDataSource{
    
    @IBOutlet weak var tvProfe: UITableView!
    
    var arregloProfesores2:[Profesor]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarProfesores()
        tvProfe.dataSource=self
        tvProfe.rowHeight=120
        
        NotificationCenter.default.addObserver(self, selector: #selector(actualizarListaProfesores), name: Notification.Name("ProfesorGuardado"), object: nil)

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloProfesores2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let v2=tvProfe.dequeueReusableCell(withIdentifier: "itemProfesor2") as! ItemmProfesorTableViewCell
        v2.lblIdProfe .text="CODIGO : "+String(arregloProfesores2[indexPath.row].idProfesor)
        v2.lblNombreProfe.text="NOMBRE : "+arregloProfesores2[indexPath.row].nombreProfesor
        return v2
    }
    

    
    
    
    
    @objc func actualizarListaProfesores() {
            cargarProfesores()
        }
    
    
   
    func cargarProfesores(){
            AF.request("https://api-moviles-2.onrender.com/profesores")
                .responseDecodable(of: [Profesor].self){ x in
                    guard let info=x.value else {return}
                    self.arregloProfesores2=info
                    self.tvProfe.reloadData()
                    print(info)
                }
    }
    
    
    
    @IBAction func btnNuevoProfesor(_ sender: UIButton) {
        performSegue(withIdentifier: "lkNuevoProfesor", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pantallaP=segue.destination as! NuevoProfesorViewController
    }
}
