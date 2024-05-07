//
//  ItemAlumnoTableViewCell.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 6/05/24.
//

import UIKit

class ItemAlumnoTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblApellido: UILabel!
    @IBOutlet weak var imgAlumno: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
