//
//  CalendarHeaderView.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 30/11/21.
//

import UIKit
import SnapKit

open class LACalendarMonthHeaderView: UICollectionReusableView, LAHeaderViewSetupProtocol {
    
    open var dateInterval: DateInterval?
    
    open var weekDays: [String] = {
        let formatter = DateFormatter()
        return formatter.veryShortWeekdaySymbols.map({String($0.prefix(1))})
    }()
    open var offset = 1
    
    open var stackdays: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        configureLayout()
    }
    
    open func configureLayout() {
        addSubview(stackdays)
        stackdays.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // clear
        stackdays.removeAllArrangedSubviews()
        
        for index in weekDays.indices {
            let label = UILabel()
            label.backgroundColor = .cyan.withAlphaComponent(0.8)
            let day = weekDays[(offset + index) % weekDays.count] // offset to present monday at first
            label.text = day
            label.textAlignment = .center
            stackdays.addArrangedSubview(label)
        }
    }
    
    open func configure(for dateInterval: DateInterval) {
        self.dateInterval = dateInterval
        configureLayout()
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for stacksub in arrangedSubviews {
            stacksub.removeFromSuperview()
        }
    }
}
