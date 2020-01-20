//
//  MyCustomCellTableViewCell.swift
//  PushLib
//
//  Created by 株式会社シナブル on 2019/10/08.
//  Copyright © 2019 株式会社シナブル. All rights reserved.
//

import UIKit

class MyCustomCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var chkread: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
