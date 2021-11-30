//
//  CalendarDayCell.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 30/11/21.
//

import Foundation
import SnapKit

open class LACalendarDayCell: UICollectionViewCell, LACalendarDayClickProtocol {
    
    open var click: (() -> Void)?
    
    open var label: UILabel = {
        let view = UILabel()
        return view
    }()
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configureLayout()
    }
    
    open func clear() {
        label.textAlignment = .center
        label.textColor = .white
    }

    open func configureLayout() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo((UIScreen.main.bounds.width - 32)/7)
        }
        label.backgroundColor = .cyan.withAlphaComponent(0.3)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        click = nil
    }
    
    open func didClick() {
        click?()
    }
    
    open func setupDay(for date: Date) {
        label.textAlignment = .center
        label.text = "\(date.day())"
    }
}
