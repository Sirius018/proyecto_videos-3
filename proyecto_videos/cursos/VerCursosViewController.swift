//
//  VerCursosViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 6/05/24.
//

import UIKit
import Alamofire

class VerCursosViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var cvCursos: UICollectionView!
    var arregloCursos : [Cursos] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
            cvCursos.delegate = self
        cvCursos.dataSource = self
        cargarCursos()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arregloCursos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configura y devuelve la celda para el índice dado
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cursoitemm", for: indexPath) as! ItemCursoCollectionViewCell
        
        // Configura la celda con los datos correspondientes
        let item = arregloCursos[indexPath.item]
        
        // Configurar la celda con los datos
        cell.imgCurso.image = UIImage(named:  "curso4.png")
        cell.lblNombreCurso.text = item.nombre
        
        return cell

    }
    
    
    func cargarCursos() {
        AF.request("https://api-moviles-2.onrender.com/cursos").responseDecodable(of: [Cursos].self) { response in
            switch response.result {
            case .success(let cursos):
                // Procesa los datos
                self.arregloCursos = cursos
                print(cursos)
                DispatchQueue.main.async {
                    self.cvCursos.reloadData()
                }
            case .failure(let error):
                print("Error al cargar los cursos: \(error)")
            }
        }
    }
   

}
