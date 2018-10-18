//
//  TableViewCell.swift
//  Profiling
//
//  Created by CARLOS EDUARDO GONZALEZ ALVAREZ on 10/17/18.
//  Copyright © 2018 CARLOS EDUARDO GONZALEZ ALVAREZ. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
