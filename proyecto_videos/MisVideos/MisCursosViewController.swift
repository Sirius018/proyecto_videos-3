//
//  MisCursosViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit
import Alamofire
class MisCursosViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    let defaults = UserDefaults.standard

    
    @IBOutlet weak var tvMisCursos: UITableView!
    var arregloMisCurso:[Cursos]=[]
    var bean:Profesor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sesion = defaults.dictionary(forKey: "sesion")
        let idUsuario = sesion!["id"]  as? Int
        print(idUsuario)
            // Llamamos a la función buscarCursos con el idUsuario obtenido
        buscarCursos(idUsuario: 10)
       

        tvMisCursos.dataSource=self
        tvMisCursos.delegate = self
        tvMisCursos.rowHeight=120

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloMisCurso.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let v2=tvMisCursos.dequeueReusableCell(withIdentifier: "itemMisCursos") as! ItemMisCursosTableViewCell
        
        v2.lblNombreCurso.text=String(arregloMisCurso[indexPath.row].nombre)
        v2.lblDescripcion.text=String(arregloMisCurso[indexPath.row].descripcion)
        return v2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "verClasePorCurso", sender: nil)

    }
    func buscarCursos(idUsuario: Int) {
        // URL de la API y endpoint para buscar usuarios por email
        let urlString = "https://api-moviles-2.onrender.com/cursosPorusuario"
        
        // Configurar los parámetros de la solicitud POST si es necesario
        let parameters: [String: Any] = [
            "id": idUsuario
            // Aquí puedes agregar más parámetros si es necesario
        ]
        
        // Realizar la solicitud con Alamofire
        AF.request(urlString, method: .post, parameters: parameters).responseDecodable(of: [Cursos].self) { response in
            switch response.result {
            case .success(let usuario):
                self.arregloMisCurso = usuario
                print(usuario)
                self.tvMisCursos.reloadData()
                
            case .failure(let error):
                print("Error al cargar los profesores: \(error)")
            }
        }
    }
}
