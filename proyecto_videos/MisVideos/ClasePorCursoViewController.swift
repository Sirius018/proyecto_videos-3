//
//  ClasePorCursoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit
import Alamofire
class ClasePorCursoViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var tvClases: UITableView!
    var arregloClasesPorCurso:[Clase]=[]
    var bean:Clase!
    var id="16"
    override func viewDidLoad() {
        super.viewDidLoad()
        buscarClases(idCurso: id)
        tvClases.dataSource=self
        tvClases.delegate = self
        tvClases.rowHeight=250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloClasesPorCurso.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verVideo" {
            let v2 = segue.destination as! PlayerViewController
            v2.bean = arregloClasesPorCurso[tvClases.indexPathForSelectedRow!.row]
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let v2=tvClases.dequeueReusableCell(withIdentifier: "itemClasesPorCurso") as! ItemClasePorCursoTableViewCell
        
        v2.lblNumeroClase.text=String(arregloClasesPorCurso[indexPath.row].numeroClase)
        v2.lblNombreClase.text=String(arregloClasesPorCurso[indexPath.row].nombre)
        v2.url = String(arregloClasesPorCurso[indexPath.row].enlace)
        
        return v2
    }
    func buscarClases(idCurso: String) {
        // URL de la API y endpoint para buscar usuarios por email
        let urlString = "https://api-moviles-2.onrender.com/clases/\(idCurso)"
        
        // Configurar los parámetros de la solicitud POST si es necesario
        let parameters: [String: Any] = [
            "id": idCurso
        ]
        
        AF.request(urlString, parameters: parameters).responseDecodable(of: [Clase].self) { response in
            switch response.result {
            case .success(let info):
                // Imprimir la respuesta del servidor antes de la deserialización
                print("Respuesta del servidor:", info)
                for clase in info {
                    var bean = Clase(id: clase.id, nombre: clase.nombre, enlace: clase.enlace, numeroClase: clase.numeroClase, estado: clase.estado, idCurso: clase.idCurso)
                    
                    self.arregloClasesPorCurso.append(bean)
                }
            
 
                print(self.arregloClasesPorCurso)
                self.tvClases.reloadData()
                        
            case .failure(let error):
                print("Error al cargar los cursos: \(error)")
            }
        }


    }
    @IBAction func regresarListaClases(segue:UIStoryboardSegue!){
        
        //dismiss(animated: true)
    }
}
