//
//  CalendarCollection.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 30/11/21.
//

import UIKit
import SnapKit

public protocol LACalendarDayClickProtocol {
    func didClick()
}

public protocol LAHeaderViewSetupProtocol {
    func configure(for dateInterval: DateInterval)
}

open class LACalendarCollection<Cell: UICollectionViewCell, HeaderView: UICollectionReusableView & LAHeaderViewSetupProtocol>: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public typealias CalendarBuilder = ((Cell, Date, DateInterval) -> Void)
    
    // Configuration Variables
    open var dateInterval: DateInterval = DateInterval(start: Date.now, end: Date.now)
    open var weeks: Int = 6
    
    // Builder
    open var cellBuilder: CalendarBuilder?
    open var didSelect: ((IndexPath) -> Void)?
    open var cellHeight: CGFloat = 48
    open var headerHeight: CGFloat = 44
    open var spacing: CGFloat = 12
    open var headerSpacing: CGFloat = 16
    open var footerSpacing: CGFloat = 16
    
    open func collectionExpectedHeight(for numberOfWeeks: Int) -> CGFloat {
        return headerSpacing + headerHeight + CGFloat(numberOfWeeks) * (cellHeight + spacing) + footerSpacing
    }
    
    open lazy var collection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = spacing
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = CGSize(width: ((UIScreen.main.bounds.size.width - 36) / 7),
                                              height: cellHeight)
        flowLayout.headerReferenceSize = CGSize(width: 0, height: headerHeight)
        
        let view = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.className)
        view.register(HeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HeaderView.className)
        
        view.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
        
        return view
    }()
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        configureLayout()
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isScrollEnabled = false
    }
    
    open func configureLayout() {
        addSubview(collection)
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Collection DataSource and Delegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dateInterval.duration > 3 * .oneWeek {
            return dateInterval.numberOfWeeks() * 7
        } else {
            return dateInterval.weeks() * 7
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: HeaderView.className,
                                                                     for: indexPath) as? HeaderView ?? HeaderView()
        header.configure(for: dateInterval)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.className, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }

        let timeZoneOffsetHours = TimeZone.current.secondsFromGMT() / 3600
        if dateInterval.duration > 3 * .oneWeek {
            var startDate = dateInterval.start.firstDayCurrentWeek().setHour(12 + timeZoneOffsetHours)
            startDate = startDate.addingTimeInterval(TimeZone.current.daylightSavingTimeOffset(for: startDate))

            if dateInterval.start.weekday() == 1 {
                startDate = dateInterval.start.addingTimeInterval(-.oneDay).firstDayCurrentWeek()
            }
            
            // 12 number magic is to cover the daylight change
            var date = startDate.setHour(12 + timeZoneOffsetHours).addingTimeInterval(.oneDay * Double(indexPath.row)).setHour(12 + timeZoneOffsetHours)
            date = date.addingTimeInterval(TimeZone.current.daylightSavingTimeOffset(for: date))
            cellBuilder?(cell, date, dateInterval)
        } else {
            var date = dateInterval.start.setHour(12 + timeZoneOffsetHours).addingTimeInterval(.oneDay * Double(indexPath.row)).setHour(12 + timeZoneOffsetHours)
            date = date.addingTimeInterval(TimeZone.current.daylightSavingTimeOffset(for: date))
            cellBuilder?(cell, date, dateInterval)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as? LACalendarDayClickProtocol else { return }
        cell.didClick()
    }
}
