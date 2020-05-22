//
//  CustomCell.swift
//  Contacts TableView
//
//  Created by Srans022019 on 21/05/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    //instance of viewcontroller
    var link : ViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(onTapFavourate), for: .touchUpInside)
        accessoryView = starButton
    }
    
    @objc func onTapFavourate() {
        link?.callSomeMethodFromCell(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
