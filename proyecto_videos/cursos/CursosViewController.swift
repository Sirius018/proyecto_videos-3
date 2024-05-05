//
//  CursosViewController.swift
//  proyecto_videos
//
//  Created by DAMII on 5/05/24.
//

import UIKit
import Alamofire
class CursosViewController: UIViewController,UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout {
   
    var listaCursos : [Cursos] = []

    @IBOutlet weak var cvCursos: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarCursos()
        cvCursos.dataSource=self
        cvCursos.delegate=self
        //cambiar alto de la celda
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaCursos.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let p2=cvCursos.dequeueReusableCell(withReuseIdentifier: "cursoItem", for: indexPath) as! CursoItemCollectionViewCell
        //
        p2.imgCursos.frame.size=CGSize(width: 180, height: 240)
        p2.lblCursos.frame.size=CGSize(width: 180, height: 40)
        p2.imgCursos.image=UIImage(named: listaCursos[indexPath.row].categoria)
        p2.lblCursos.text=listaCursos[indexPath.row].nombre
        return p2
    }
    
    
    @IBAction func btnNuevoCurso(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoCurso", sender: nil)

    }
    
    
    func cargarCursos(){
            AF.request("https://api-moviles-2.onrender.com/cursos")
                .responseDecodable(of: [Cursos].self){ data in
                    guard let info=data.value else {return}
                    self.listaCursos=info
                    self.cvCursos.reloadData()
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 180, height: 305)
    }

}
