//
//  CalendarCell.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 30/11/21.
//

import UIKit
import SnapKit

open class LACalendarTableCell<DayCell: UICollectionViewCell, HeaderView: UICollectionReusableView & LAHeaderViewSetupProtocol>: UITableViewCell {
    
    open lazy var calendar: LACalendarCollection<DayCell, HeaderView> = {
        let view = LACalendarCollection<DayCell, HeaderView>()
        return view
    }()
    
    open func setupCalendar(for interval: DateInterval) {
        calendar.dateInterval = interval
        let height = calendar.collectionExpectedHeight(for: interval.weeks())
        
        // Configure layout
        contentView.addSubview(calendar)
        calendar.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}
