//
//  Date.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 30/11/21.
//

import Foundation

enum DateFormat {
    case monthDay
    case hoursMinutes
    case birthdate
    case calendarDate
    case iso
    case naturalMonth
    case naturalMonthTime
    case hour24
    case hour12
    case full
    case fullMiliseconds
    case almostFull
    case describingDay
    case shortYear
    case custom(String)
    
    var value: String {
        switch self {
        case .hoursMinutes: return "h.mm"
        case .naturalMonth: return "dd MMM yyyy"
        case .naturalMonthTime: return "dd MMM yyyy, HH:mm"
        case .birthdate: return "dd MM yyyy"
        case .monthDay: return "MMM, dd"
        case .calendarDate: return "dd/MM/yyyy"
        case .iso: return "yyyy-MM-dd"
        case .hour12: return "hh:mm aaa" // 05:30 PM
        case .hour24: return "HH:mm" // 17:30
        case .almostFull: return "yyyy-MM-dd'T'HH:mm:ss" // 2021-07-28T01:00:00
        case .full: return "yyyy-MM-dd'T'HH:mm.ss.SSSZ" // 2021-08-11T15:55:50.115Z
        case .fullMiliseconds: return "yyyy-MM-dd'T'HH:mm.ss.SSSSSS" // 2021-09-03T09:51:21.011282
        case .describingDay: return "EEEE dd MMM" // Friday 13 Aug
        case .shortYear: return "dd MMM YYYY" // 13 Aug 1900
        case .custom(let pattern): return pattern
        }
    }
    
    static func getDate(for string: String?) -> Date? {
        for format in [DateFormat.iso, .birthdate, .almostFull, .naturalMonth, .describingDay] {
            if let date = string?.date(format) {
                return date
            }
        }
        
        return nil
    }
}

extension Date {
    
    var describe: String {
        self.stringDate(as: .full)
    }
    
    static var now: Date { Date() }
    static var isoNow: String { Date.now.stringDate(as: .iso) }
    static var dateTimeNow: String { Date.now.stringDate(as: .almostFull) }
    
    static var calendar: Calendar { Calendar.current }
    var calendar: Calendar { Calendar.current }
    
    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func isThisMonth() -> Bool {
        return sameMonthOf(date: Date.now)
    }
    
    func firstDayOfTheMonth() -> Date {
        self.setDay(1).resetHour()
    }
    
    func firstDayNextMonth() -> Date {
        self.setDay(1).resetHour().addingTimeInterval(.oneDay * 33).setDay(1).resetHour()
    }
    
    func lastDayOfTheMonth() -> Date {
        firstDayNextMonth().backOneDay().setLastHour()
    }
    
    /// Returns the first and last hour of the month
    func monthInterval() -> DateInterval {
        let start = self.firstDayOfTheMonth()
        let end = start.lastDayOfTheMonth()
        return DateInterval(start: start, end: end)
    }
    
    func sameAs(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return self.compare(date) == .orderedSame
    }
    
    func backOneDay() -> Date {
        self.resetHour().addingTimeInterval(-(.oneHour * 12)).resetHour()
    }
    
    func sameDayOf(date other: Date) -> Bool {
        let selfComponents = calendar.dateComponents([.month, .day, .year], from: self.resetHour())
        let todayComponents = calendar.dateComponents([.month, .day, .year], from: other.resetHour())
        return selfComponents == todayComponents
    }
    
    func sameDayOfWithTimezone(date other: Date) -> Bool {
        let selfComponents = calendar.dateComponents([.month, .day, .year], from: self.resetHour())
        let todayComponents = calendar.dateComponents([.month, .day, .year], from: other.resetHour())
        return selfComponents == todayComponents
    }
    
    func sameMonthOf(date other: Date) -> Bool {
        let selfComponents = calendar.dateComponents([.month, .year], from: self.resetHour())
        let todayComponents = calendar.dateComponents([.month, .year], from: other.resetHour())
        return selfComponents == todayComponents
    }
    
    func era() -> Int {
        let selfComponents = calendar.dateComponents([.era], from: self)
        return selfComponents.era ?? 1
    }
    
    func timeZone() -> TimeZone {
        let selfComponents = calendar.dateComponents([.timeZone], from: self)
        return selfComponents.timeZone ?? .current
    }
    
    func year() -> Int {
        let selfComponents = calendar.dateComponents([.year], from: self)
        return selfComponents.year ?? 1
    }
    
    func month() -> Int {
        let selfComponents = calendar.dateComponents([.month], from: self)
        return selfComponents.month ?? 1
    }
    
    func day() -> Int {
        let selfComponents = calendar.dateComponents([.day], from: self)
        return selfComponents.day ?? 1
    }
    
    func hour() -> Int {
        let selfComponents = calendar.dateComponents([.hour], from: self)
        return selfComponents.hour ?? 1
    }
    
    func minute() -> Int {
        let selfComponents = calendar.dateComponents([.minute], from: self)
        return selfComponents.minute ?? 1
    }
    
    func second() -> Int {
        let selfComponents = calendar.dateComponents([.second], from: self)
        return selfComponents.second ?? 1
    }
    
    func weekday() -> Int {
        let selfComponents = calendar.dateComponents([.weekday], from: self)
        return selfComponents.weekday ?? 1
    }
    
    func dateComponents() -> DateComponents {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = self.month()
        components.day = self.day()
        components.minute = self.minute()
        components.hour = self.hour()
        components.second = self.second()
        return components
    }
    
    func setDay(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = self.month()
        components.day = value
        components.minute = self.minute()
        components.hour = self.hour()
        components.second = self.second()
        return components.date ?? self
    }
    
    func setMonth(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = value
        components.day = self.day()
        components.minute = self.minute()
        components.hour = self.hour()
        components.second = self.second()
        return components.date ?? self
    }
    
    func setYear(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = value
        components.month = self.month()
        components.day = self.day()
        components.minute = self.minute()
        components.hour = self.hour()
        components.second = self.second()
        return components.date ?? self
    }
    
    func resetHour() -> Date {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.era = era()
        components.year = year()
        components.month = month()
        components.day = day()
        components.minute = 0
        components.hour = 0
        components.second = 0
        return components.date ?? self
    }
    
    func setHour(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = self.month()
        components.day = self.day()
        components.minute = self.minute()
        components.hour = value
        components.second = self.second()
        return components.date ?? self
    }
    
    func setMinute(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = self.month()
        components.day = self.day()
        components.minute = value
        components.hour = self.hour()
        components.second = self.second()
        return components.date ?? self
    }
    
    func setSeconds(_ value: Int) -> Date {
        var components = DateComponents()
        components.calendar = calendar
        components.era = self.era()
        components.year = self.year()
        components.month = self.month()
        components.day = self.day()
        components.minute = self.minute()
        components.hour = self.hour()
        components.second = value
        return components.date ?? self
    }
    
    func setLastHour() -> Date {
        let date = resetHour()
        var components = DateComponents()
        components.calendar = calendar
        components.era = date.era()
        components.year = date.year()
        components.month = date.month()
        components.day = date.day()
        components.minute = 59
        components.hour = 23
        components.second = 59
        return components.date ?? date
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self) ?? self
    }
    
    /// Total number of weeks starting on sunday
    func numberOfWeeks() -> Int {
        let startDate = self.setDay(1)
        let endDate = startDate.setMonth(self.month() + 1).addingTimeInterval(-86399)
        return DateInterval(start: startDate, end: endDate).numberOfWeeks()
    }
    
    func firstDayCurrentWeek() -> Date {
        let diffDays = Double(2 - self.weekday())
        return self.addingTimeInterval(.oneDay * diffDays)
    }
    
    func isAfter(_ date: Date) -> Bool {
        return self.timeIntervalSince1970 > date.timeIntervalSince1970
    }
    
    func stringDate(as format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value
        dateFormatter.defaultDate = Date()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}

extension DateInterval {
    
    var calendar: Calendar {
        var current = Calendar.current
        current.firstWeekday = 2
        return current
    }
    
    /// Total number of weeks starting on sunday
    func numberOfWeeks() -> Int {
        return weeks()
//        let days = (calendar.dateComponents([.day], from: self.start, to: self.end).day ?? 0)
//
//        let startDay = ( (start.weekday() - 1) % 7) > 0 ? start.weekday() : 7
//        let endDay = (end.weekday() - 1) > 0 ? end.weekday() : 7
//
//        let startingDayCount = startDay
//        let endingDayCount = abs(endDay - 7)
//        let weeks = Int(ceil( (Double(startingDayCount + endingDayCount) + Double(days))/7.0 ))
//
//        return weeks
    }
    
    /// Does not consider current day of the week
    func weeks() -> Int {
        
        var newStart = start
        
        if start.weekday() == 1 {
            newStart = start.addingTimeInterval(-.oneDay)
        }
        
        return Int(ceil(DateInterval(start: newStart.firstDayCurrentWeek(), end: end).duration / .oneWeek))
    }
}

extension TimeInterval {
    @nonobjc static var oneMinute: TimeInterval { 60 }
    @nonobjc static var oneHour: TimeInterval { oneMinute * 60 }
    @nonobjc static var oneDay: TimeInterval { oneHour * 24 }
    @nonobjc static var oneWeek: TimeInterval { oneDay * 7 }
}

extension String {
    func date(_ format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value
        dateFormatter.defaultDate = Date()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}
