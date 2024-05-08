//
//  ItemClasePorCursoTableViewCell.swift
//  proyecto_videos
//
//  Created by Judith Chavez on 7/05/24.
//

import UIKit
import YouTubePlayer_Swift
class ItemClasePorCursoTableViewCell: UITableViewCell {

    @IBOutlet weak var btnVerClase: UIButton!
    @IBOutlet weak var lblNombreClase: UILabel!
  
    @IBOutlet weak var lblNumeroClase: UILabel!
    var url:String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnVerClase(_ sender: UIButton) {
        guard let videoURL = URL(string: url) else {
            // Manejar el caso en que la URL no sea válida
            return
        }
        //playerView.loadVideoID(videoURL)
    }
    
}
