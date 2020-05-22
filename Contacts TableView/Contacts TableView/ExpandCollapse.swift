//
//  ExpandCollapse.swift
//  Contacts TableView
//
//  Created by Srans022019 on 21/05/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import Foundation
import Contacts

struct ExpandCollapse {
    var isExpandable : Bool
    var names : [FavouritableContact]
}

struct FavouritableContact {
    let contact : CNContact
    var isFavourite : Bool
}
