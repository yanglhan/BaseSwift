//
//  EPDatePickerView.swift
//  EPPlay
//
//  Created by TEZWEZ on 2019/8/14.
//  Copyright © 2019 YuXiTech. All rights reserved.
//

import UIKit

class EPDatePickerView: UIView {

    enum DatePickerType: Int {
        case `default`//year-month-day
        case month//year-month
        case day//month-day
    }
    
    var pickerType: DatePickerType?
    var tColor: UIColor = .theme
    var tFont: UIFont = UIFont(name: pingFangMedium, size: 18)!
    var initialDate: Date = Date()
    var minDate: Date?
    var maxDate: Date?
    var minYear: Int = 2019
    var maxYear: Int = 2019
    
    private var days: [String] = []
    private var months: [String] = []
    private var years: [String] = []
    private let kLabTag:Int = 100
    private let kRowHeight: CGFloat = 44
    
    // MARK: Life cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, type: DatePickerType = .default, initialDate: Date = Date(), minDate: Date? = nil, maxDate: Date? = nil, textColor: UIColor = .theme, textFont: UIFont = UIFont(name: pingFangMedium, size: 18)!) {
        super.init(frame: frame)
        self.backgroundColor = .clear//UIColor(rgb: 0x1F1F48)

        self.pickerType = type
        self.initialDate = initialDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.tColor = textColor
        self.tFont = textFont
        
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalToSuperview()
        }
        
        //init data
        self.configData()
    }

    // MARK: Getter & Setter
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView(frame: self.bounds)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .clear
        return picker
    }()
    
    private lazy var formatter: DateFormatter = {
        let df = DateFormatter()
        return df
    }()
}

// MARK: - public func
extension EPDatePickerView {
    ///当前选择的时间
    public func myDate() -> Date? {
        //年
        var year = "\(maxYear)"
        if pickerType == .default {
            year = years[(pickerView.selectedRow(inComponent: 0)) % years.count]
        }
        //月
        let monthIndex = (pickerType != .day) ? 1 : 0
        let month = months[(pickerView.selectedRow(inComponent: monthIndex)) % months.count]
        //日
        days = self.nameOfDay(month)
        let dayIndex = (pickerType == .default) ? 2 : 1
        let day = days[(pickerView.selectedRow(inComponent: dayIndex)) % days.count]
        
        var string = year + "-" + month + "-" + day
        if pickerType == .month {
            string = year + "-" + month
            formatter.dateFormat = "yyyy-MM"
        } else if pickerType == .day {
            string = month + "-" + day
            formatter.dateFormat = "MM-dd"
        } else {
            string = year + "-" + month + "-" + day
            formatter.dateFormat = "yyyy-MM-dd"
        }
        
        let date = formatter.date(from: string)
        
        return date!
    }
}

// MARK: - private func
extension EPDatePickerView {
    ///config data
    private func configData() {
        if minDate != nil, maxDate != nil, (minDate?.timeIntervalSince1970 ?? 0) > (maxDate?.timeIntervalSince1970 ?? 0) {
            maxDate = minDate
        }
        minYear = Int(self.currentYearName(minDate ?? Date()))!
        maxYear = Int(self.currentYearName(maxDate ?? Date()))!
        
        self.years = self.nameOfYears()
        self.months = self.nameOfMonths()
        self.days = self.nameOfDay(self.currentMonthName(initialDate))
        
        self.selectOneDay(initialDate)
    }
    
    ///创建年/月/日的数据源
    private func nameOfMonths() -> Array<String> {
        for month in 1...12 {
            months.append("\(month)")
        }
        return months
    }
    
    private func nameOfYears() -> Array<String> {
        var years: [String] = []
        for year in minYear...maxYear {
            years.append("\(year)")
        }
        return years
    }
    
    private func nameOfDay(_ currentMonth: String!) -> Array<String> {
        var dayNum = 31
        if ["01", "1", "03", "3", "05", "5", "07", "7", "08", "8", "10", "12"].contains(currentMonth) {
            dayNum = 31
        } else if ["04", "4", "06", "6", "09", "9", "11"].contains(currentMonth) {
            dayNum = 30
        } else {
            var cYear = maxYear
            if pickerType == .default {
                let yearCount:Int = (years.count)
                cYear = Int(years[(pickerView.selectedRow(inComponent: 0)) % yearCount]) ?? maxYear
            }
            
            if cYear % 4 == 0, cYear % 100 != 0 {
                dayNum = 29
            } else if cYear % 400 == 0 {
                dayNum = 29
            } else {
                dayNum = 28
            }
        }
        
        var days: [String] = []
        for day in 1...dayNum {
            days.append("\(day)")
        }

        return days
    }
    
    ///select one day
    private func selectOneDay(_ date: Date, animated: Bool = false) {
        let path = self.oneDayPath(date)
        if pickerType == .default {
            self.pickerView.selectRow(path.0, inComponent: 0, animated: animated)
            self.pickerView.selectRow(path.1, inComponent: 1, animated: animated)
            self.pickerView.selectRow(path.2, inComponent: 2, animated: animated)
        } else if pickerType == .month {
            self.pickerView.selectRow(path.0, inComponent: 0, animated: animated)
            self.pickerView.selectRow(path.1, inComponent: 1, animated: animated)
        } else if pickerType == .day {
            self.pickerView.selectRow(path.1, inComponent: 0, animated: animated)
            self.pickerView.selectRow(path.2, inComponent: 1, animated: animated)
        }
    }
    
    /// date （year, month, day）
    private func oneDayPath(_ date: Date) -> (Int, Int, Int) {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        let currentmonth = self.currentMonthName(date)
        let currentYear = self.currentYearName(date)
        let currentDay = self.currentDayName(date)
        
        let yCount:Int = self.years.count
        for elem in 0..<yCount{
            let cellYear = years[elem] as String
            if cellYear == currentYear {
                let currentRow:Int = (self.years.firstIndex(of: cellYear))!
                year = currentRow
                break
            }
        }
        
        let mCount:Int = self.months.count
        for elem in 0..<mCount{
            let cellMonth = months[elem] as String
            if cellMonth.toDouble() == currentmonth.toDouble() {
                let currentRow:Int = (self.months.firstIndex(of: cellMonth))!
                month = currentRow
                break
            }
        }
        
        let dCount:Int = self.days.count
        for elem in 0..<dCount{
            let cellDay = days[elem] as String
            if cellDay == currentDay {
                let currentRow:Int = (self.days.firstIndex(of: cellDay))!
                day = currentRow
                break
            }
        }
        
        return (year, month, day)
    }
    
    private func rowCountDay() -> NSInteger {
        return days.count
    }
    
    private func rowCountMonth() -> NSInteger {
        return months.count
    }
    
    private func rowCountYear() -> NSInteger {
        return years.count
    }
    
    ///picker component width
    private func componentWidth() -> CGFloat {
        let componentNum = (pickerType == .default) ? 3 : 2
        let numberOfComponent: CGFloat = (CGFloat)(componentNum)
        return self.bounds.size.width / numberOfComponent
    }
    
    ///picker label
    private func labelForComponent(component:Int , Selected selected:Bool) -> UILabel {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.componentWidth(), height: kRowHeight))
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.textColor = tColor//selected ? tColor : UIColor.black
        label.font = tFont
        label.isUserInteractionEnabled = false
        label.tag = kLabTag
        return label
    }
    
    ///picker label text
    private func titleForRow(row:Int ,forComponent component:Int) -> String {
        if pickerType == .default {
            if component == 0 {//year
                let yearCount:Int = self.years.count
                return self.years[row % yearCount] + " " + "年".localized()
            } else if component == 1 {//month
                let monthCount:Int = self.months.count
                return self.months[row % monthCount] + " " + "月".localized()
            } else if component == 2 {//day
                let dayCount:Int = self.days.count
                return self.days[row % dayCount] + " " + "日".localized()
            }
        } else if pickerType == .month {
            if component == 0 {//year
                let yearCount:Int = self.years.count
                return self.years[row % yearCount] + " " + "年".localized()
            } else if component == 1 {//month
                let monthCount:Int = self.months.count
                return self.months[row % monthCount] + " " + "月".localized()
            }
        } else if pickerType == .day {
            if component == 0 {//month
                let monthCount:Int = self.months.count
                return self.months[row % monthCount] + " " + "月".localized()
            } else if component == 1 {//day
                let dayCount:Int = self.days.count
                return self.days[row % dayCount] + " " + "日".localized()
            }
        }
        
        return ""
    }
    
    ///formatter day
    private func currentDayName(_ date: Date) -> String {
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    ///formatter month
    private func currentMonthName(_ date: Date) -> String {
        formatter.dateFormat = "MM"
        return formatter.string(from: date)
    }
    
    ///formatter year
    private func currentYearName(_ date: Date) -> String {
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    
    ///limit date
    private func limitDateSelect() {
        if minDate != nil {
            let cDate = self.myDate()
            if cDate?.timeIntervalSince1970 ?? 0 <= minDate?.timeIntervalSince1970 ?? 0 {
                self.selectOneDay(minDate!, animated: true)
            }
        }
        
        if maxDate != nil {
            let cDate = self.myDate()
            if cDate?.timeIntervalSince1970 ?? 0 >= maxDate?.timeIntervalSince1970 ?? 0 {
                self.selectOneDay(maxDate!, animated: true)
            }
        }
    }
}

// MARK: UIPickerViewDelegate & UIPickerViewDataSource
extension EPDatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (pickerType == .default) ? 3 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .default {
            if component == 0 {return self.rowCountYear()}
            else if component == 1 {return self.rowCountMonth()}
            else if component == 2 {return self.rowCountDay()}
        } else if pickerType == .month {
            if component == 0 {return self.rowCountYear()}
            else if component == 1 {return self.rowCountMonth()}
        } else if pickerType == .day {
            if component == 0 {return self.rowCountMonth()}
            else if component == 1 {return self.rowCountDay()}
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let returnView = (view?.tag == kLabTag) ? (view as? UILabel) : self.labelForComponent(component: component, Selected: true)
        returnView?.text = self.titleForRow(row: row, forComponent: component)
        return returnView!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == .default {
            if component == 0 {
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
            } else if component == 1 {
                let month = months[(pickerView.selectedRow(inComponent: 1)) % months.count]
                days = self.nameOfDay(month)
                pickerView.reloadComponent(2)
            }
        } else if pickerType == .month {
            if component == 0 {
                pickerView.reloadComponent(1)
            }
        } else if pickerType == .day {
            if component == 0 {
                let month = months[(pickerView.selectedRow(inComponent: 0)) % months.count]
                days = self.nameOfDay(month)
                pickerView.reloadComponent(1)
            }
        }
        
        //判断时间是否超限
        self.limitDateSelect()
    }
}
