//
//  ItemMisCursosTableViewCell.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit

class ItemMisCursosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblNombreCurso: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
