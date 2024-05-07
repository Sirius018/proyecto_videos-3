import UIKit

class ItemmProfesorTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfesor: UIImageView!
    
    @IBOutlet weak var lblIdProfe: UILabel!
    
    @IBOutlet weak var lblNombreProfe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
