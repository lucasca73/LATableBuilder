//
//  DetailViewController.swift
//  LATableBuilder_Example
//
//  Created by Lucas Costa Araujo on 29/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LATableBuilder

class DetailViewController: LATableBuilderController {
    
    var clicks = 1
    
    override func buildTable() {
        super.buildTable()
        
        // Using counter on addTables makes the reload more fluid than calling buildTable
        let builder = addTable(cell: STBaseGenericCell.self)
        
        builder.setupBuilder { index, cell in
            cell.didClick = { _ in
                self.clicks += 1
                self.reload()
            }
            cell.textLabel?.text = "Cell - \(index.row)"
        }
        
        builder.setupCounter { self.clicks }
        
        reload()
    }
}
