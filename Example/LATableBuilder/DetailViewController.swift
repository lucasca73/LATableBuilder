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
    
    var fixedHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "CALENDAR"
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        return view
    }()
    
    override func buildTable() {
        super.buildTable()
        
        setupStackViews([fixedHeaderView, tableView])
        
        setupCalendar()
        setupClicker()
        
        reload()
    }
    
    func setupCalendar() {
        let interval = DateInterval(start: Date(), duration: 2600000)
        add(cell: (LACalendarTableCell<LACalendarDayCell, LACalendarMonthHeaderView>).self) { cell in
            cell.setupCalendar(for: interval)
            cell.calendar.cellBuilder = self.setupDayCell
        }
    }
    
    func setupDayCell(_ cell: LACalendarDayCell, _ date: Date, _ interval: DateInterval) {
        cell.setupDay(for: date)
        cell.configureLayout()
        
        cell.click = {
            debugPrint("[DEBUG] click on \(date)")
        }
    }
    
    func setupClicker() {
        // Using counter on addTables makes the reload more fluid than calling buildTable
        let builder = addTable(cell: UITableViewCell.self)
        
        builder.setupBuilder { index, cell in
            cell.textLabel?.text = "Cell - \(index.row)"
        }
        
        builder.setupDidSelect { [weak self] index in
            self?.clicks += 1
            self?.reload()
        }
        
        builder.setupCounter { self.clicks }
    }
}
