//
//  NuevoCursoViewController.swift
//  proyecto_videos
//
//  Created by DAMII on 5/05/24.
//

import UIKit

class NuevoCursoViewController: UIViewController {

   
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtProfesor: UITextField!
    
    @IBOutlet weak var txtCategoria: UITextField!
    
    @IBOutlet weak var txtCaracteristicas: UITextField!
    
    @IBOutlet weak var txtEstado: UITextField!
    
    @IBOutlet weak var rbtnNo: UIButton!
    
    @IBOutlet weak var rbtnSi: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rbtnNo.setImage(UIImage(named: "radio_off"), for: .normal)
        rbtnNo.setImage(UIImage(named: "radio_on"), for: .selected  )
        rbtnSi.setImage(UIImage(named: "radio_off"), for: .normal)
        rbtnSi.setImage(UIImage(named: "radio_on"), for: .selected  )
    }
    
    var act : Int = 0
    @IBAction func Actividad(_ sender: UIButton) {
        if sender == rbtnSi {
            rbtnSi.isSelected=true
            rbtnNo.isSelected=false
            act = 1
        }
        else if sender == rbtnNo {
            rbtnSi.isSelected=false
            rbtnNo.isSelected=true
            act = 2
        }
    }
    
    @IBAction func btnRegistrar(_ sender: Any) {
        
       
            let nombre = txtNombre.text ?? ""
            let idProfesor = Int(txtProfesor.text ?? "0") ?? 0
            let categoria = txtCategoria.text ?? ""
            let descripcion = txtCaracteristicas.text ?? ""
            let estado = txtEstado.text ?? ""
            let activ = rbtnSi.isSelected
                    
            // Crear el objeto curso
            let curso = Cursos(nombre: nombre, descripcion: descripcion, categoria: categoria, estado: estado, idProfesor: idProfesor, activo: true)
            
            // Convertir el objeto curso a JSON
            guard let jsonData = try? JSONEncoder().encode(curso) else {
                print("Error al convertir el objeto curso a JSON")
                return
            }
            
            // Crear la solicitud HTTP POST
            guard let url = URL(string: "https://api-moviles-2.onrender.com/cursos") else {
                print("URL inválida")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Realizar la solicitud HTTP
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Manejar la respuesta de la solicitud
                if let error = error {
                    print("Error en la solicitud: \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300).contains(httpResponse.statusCode) {
                        print("Curso registrado exitosamente")
                        // Aquí puedes realizar cualquier acción adicional después de registrar el curso, como mostrar una alerta o navegar a otra pantalla
                    } else {
                        print("Error al registrar el curso. Código de estado HTTP: \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        
        
        
        
    }
    
    
    
    
    
    
}
