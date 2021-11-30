//
//  ViewModel.swift
//  LATableBuilder_Example
//
//  Created by Lucas Costa Araujo on 17/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import LATableBuilder

class ViewModel {
    weak var controller: ViewController?
    
    var messages = [String]()
    
    var isTurnedOn: Bool = false
    
    func loadInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.messages.append("This is the first message :)")
            self.controller?.buildTable()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.messages.append("Second message :D")
            self.messages.append("A Third message 8)")
            self.messages.append("Another one *_*")
            self.messages.append("As the cells are being reused all the time, you can implement prepareForReuse method on every TableViewCell to handle it properly")
            self.controller?.buildTable()
        }
    }
}
