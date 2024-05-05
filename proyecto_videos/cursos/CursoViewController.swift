//
//  CursoViewController.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 1/05/24.
//

import UIKit
import Alamofire

class CursoViewController: UIViewController,UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

=    }
    

    
    
    
    func cargarMedicamentos(){
            AF.request("https://api-moviles-2.onrender.com/cursos")
                .responseDecodable(of: [Cursos].self){ data in
                    guard let info=data.value else {return}
                    self.arregloCursos=info
                    self.cvCursos.reloadData()
                }
    }

}
