//
//  MisCursosViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit
import Alamofire
class MisCursosViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    

    
    @IBOutlet weak var tvMisCursos: UITableView!
    let defaults = UserDefaults.standard
    var arregloMisCurso:[Cursos]=[]
    //var bean:Cursos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sesion = defaults.dictionary(forKey: "sesion")
        let idUsuario = sesion!["id"]  as? Int
        print(idUsuario)
            // Llamamos a la función buscarCursos con el idUsuario obtenido
        buscarCursos(idUsuario: "10")
       

        tvMisCursos.dataSource=self
        tvMisCursos.delegate = self
        tvMisCursos.rowHeight=250

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
    func buscarCursos(idUsuario: String) {
        // URL de la API y endpoint para buscar usuarios por email
        let urlString = "https://api-moviles-2.onrender.com/cursosPorusuario/\(idUsuario)"
        
        // Configurar los parámetros de la solicitud POST si es necesario
        let parameters: [String: Any] = [
            "id": idUsuario
        ]
        
        AF.request(urlString, method: .post, parameters: parameters).responseDecodable(of: [Cursos].self) { response in
            switch response.result {
            case .success(let cursos):
                // Imprimir la respuesta del servidor antes de la deserialización
                print("Respuesta del servidor:", cursos)
                for curso in cursos {
                    var bean = Cursos(id: curso.id, nombre: curso.nombre, descripcion: curso.descripcion, caracteristicas: curso.caracteristicas, categoria: curso.categoria, estado: curso.estado, idProfesor: curso.idProfesor, precio: curso.precio)
                    
                    self.arregloMisCurso.append(bean)
                }
                // Procesar la respuesta deserializada
                
                print(self.arregloMisCurso)
                self.tvMisCursos.reloadData()
                        
            case .failure(let error):
                print("Error al cargar los cursos: \(error)")
            }
        }


    }
}
