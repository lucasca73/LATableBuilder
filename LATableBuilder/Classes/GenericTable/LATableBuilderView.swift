//
//  LATableBuilderView.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 29/11/21.
//

import UIKit

open class LATableBuilderView: UITableView {
    public var reloadAnimation: UITableView.RowAnimation { .none }
    
    open var sections = [LASectionBuilder]()
    
    open func buildOnWillAppear() -> Bool {
        return true
    }
    
    open func setupTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    open func clearBuilders() {
        sections.removeAll()
    }
    
    open func buildTable() {
        clearBuilders()
    }
    
    open func reload(_ ids: String...) {
        reload(ids)
    }
    
    open func reload(_ ids: [String]) {
        
        if self.dataSource == nil {
            return
        }
        
        let animation: UITableView.RowAnimation = reloadAnimation
        
        if ids.isEmpty == false {
            
            var indexes = [IndexPath]()
            var indexAppending = [IndexPath]()
            var indexRemoving = [IndexPath]()
            var sectionUpdate = IndexSet()
            
            // Running through sections
            for (sectionIndex, sectionBuilder) in sections.enumerated() {
                
                // Running through builders
                for (builderIndex, builder) in sectionBuilder.builders.enumerated() {
                    for id in ids {
                        if builder.shouldReload(id: id) {
                            
                            if builder.isTable() {
                                let lastCount = self.numberOfRows(inSection: sectionIndex)
                                let currentCount = builder.getCount()
                                
                                if currentCount > lastCount {
                                    // adding
                                    for newRow in ((lastCount)..<(currentCount)) {
                                        indexAppending.append(IndexPath(row: newRow, section: sectionIndex))
                                    }
                                    
                                } else if currentCount < lastCount {
                                    // Removing
                                    for removeRow in ((currentCount)..<(lastCount)) {
                                        indexRemoving.append(IndexPath(row: removeRow, section: sectionIndex))
                                    }
                                } else {
                                    // reload
                                    sectionUpdate.insert(sectionIndex)
                                }
                            } else {
                                if let sectionId = sectionBuilder.sectionId, sectionId == id {
                                    sectionUpdate.insert(sectionIndex)
                                } else {
                                    let index = IndexPath(row: builderIndex, section: sectionIndex)
                                    indexes.append(index)
                                }
                            }
                        }
                    }
                }
            }
            
            self.beginUpdates()
            
            if indexes.isEmpty == false {
                self.reloadRows(at: indexes, with: animation)
            }
            
            if indexAppending.isEmpty == false {
                self.insertRows(at: indexAppending, with: animation)
                var secReload = IndexSet()
                for index in indexAppending {
                    secReload.insert(index.section)
                }
                self.reloadSections(secReload, with: animation)
            }
            
            if indexRemoving.isEmpty == false {
                self.deleteRows(at: indexRemoving, with: animation)
                var secReload = IndexSet()
                for index in indexRemoving {
                    secReload.insert(index.section)
                }
                self.reloadSections(secReload, with: animation)
            }
            
            if sectionUpdate.isEmpty == false {
                self.reloadSections(sectionUpdate, with: animation)
            }
            
            self.endUpdates()
            
        } else {
            self.reloadData()
        }
    }
    
    open func addSection( title: String? = nil,
                          height: CGFloat = 0,
                          reloadListener: String? = nil,
                          _ builder: LASectionViewBuilder? = nil ) {
        let sec = LASectionBuilder()
        sec.viewBuilder = builder
        sec.height = height
        sec.title = title
        sec.sectionId = reloadListener
        
        sections.append(sec)
    }
    
    @discardableResult open func add<T: UITableViewCell>(cell: T.Type,
                                                         height: CGFloat = UITableView.automaticDimension,
                                                         reloadListener: String? = nil,
                                                         builder: ((T) -> Void)? = nil ) -> LACellBuilder<T> {
        
        self.register(cellType: cell)
        let cellBuilder = LACellBuilder(type: cell, builder: builder, cellId: reloadListener)
        cellBuilder.type = cell
        cellBuilder.height = height
        
        cellBuilder.leadingEdit = nil
        cellBuilder.trailingEdit = nil
        
        if sections.last?.isTable() ?? true {
            addSection()
        }
        
        if let lastSec = sections.last {
            lastSec.builders.append(cellBuilder)
        }
        
        return cellBuilder
    }
    
    @discardableResult open func addTable<T: UITableViewCell>(cell: T.Type,
                                                              count: Int,
                                                              rowHeight: CGFloat = UITableView.automaticDimension,
                                                              reloadListener: String? = nil,
                                                              builder: ((IndexPath, T) -> Void)? = nil ) -> LATableBuilder<T> {
        
        self.register(cellType: cell)
        let tb = LATableBuilder(type: cell, builder: builder, cellId: reloadListener)
        tb.type = cell
        tb.rows = count
        tb.rowHeight = rowHeight
        
        if let sec = sections.last {
            if sec.hasBuilders() {
                addSection(reloadListener: reloadListener)
            }
        } else {
            addSection(reloadListener: reloadListener)
        }
        
        if let lastSec = sections.last {
            lastSec.builders.append(tb)
        }
        
        return tb
    }
    
    @discardableResult open func addTable<T: UITableViewCell>(cell: T.Type,
                                                              counter: @escaping (() -> Int),
                                                              reloadListener: String? = nil,
                                                              builder: ((IndexPath, T) -> Void)? = nil ) -> LATableBuilder<T> {
        
        self.register(cellType: cell)
        let tb = LATableBuilder(type: cell, builder: builder, cellId: reloadListener)
        tb.type = cell
        tb.rows = counter()
        tb.counter = counter
        
        if let sec = sections.last {
            if sec.hasBuilders() {
                addSection()
            }
        } else {
            addSection()
        }
        
        if let lastSec = sections.last {
            lastSec.builders.append(tb)
        }
        
        return tb
    }
    
    @discardableResult open func addTable<T: UITableViewCell>(cell: T.Type, reloadListener: String? = nil) -> LATableBuilder<T> {
        
        self.register(cellType: cell)
        let tb = LATableBuilder(type: cell, builder: nil, cellId: reloadListener)
        tb.type = cell
        
        if let sec = sections.last {
            if sec.hasBuilders() {
                addSection(reloadListener: reloadListener)
            }
        } else {
            addSection(reloadListener: reloadListener)
        }
        
        if let lastSec = sections.last {
            lastSec.builders.append(tb)
        }
        
        return tb
    }
    
    open func removeSection(id: String, animation: UITableView.RowAnimation = .automatic) {
        
        var removingIndexes = IndexSet()
        
        for (index, section) in sections.enumerated() where section.sectionId == id {
            section.builders.removeAll()
            removingIndexes.insert(index)
        }
        
        // finish if empty
        if removingIndexes.isEmpty {
            return
        }
        
        // Updating sections
        sections = sections.filter({$0.sectionId != id})
        
        // Updating Tableview
        self.deleteSections(removingIndexes, with: animation)
    }
    
    open func insertNewSection(id: String, animation: UITableView.RowAnimation = .automatic) {
        
        let tableViewCount = self.numberOfSections
        let currentCount = sections.count
        
        if currentCount == tableViewCount {
            var reloadIndexes = IndexSet()
            
            for (index, section) in sections.enumerated() where section.sectionId == id {
                reloadIndexes.insert(index)
            }
            
            // Reload section
            self.reloadSections(reloadIndexes, with: animation)
            
        } else if currentCount > tableViewCount {
            var appendingIndexes = IndexSet()
            
            for index in (tableViewCount..<currentCount) {
                appendingIndexes.insert(index)
            }
            
            // Insert section
            self.insertSections(appendingIndexes, with: animation)
        } else {
            
            // nothing
            return
        }
    }
    
    open func builder(for indexPath: IndexPath) -> LABuilderProtocol? {
        let section = sections[indexPath.section]
        
        if let tableBuilder = section.getTable() {
            return tableBuilder
        } else {
            // row builder
            return section.builders[indexPath.row]
        }
    }
}

extension LATableBuilderView: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].getNumberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < sections.count {
            let section = sections[indexPath.section]
            var builder: LABuilderProtocol?
            
            builder = section.getTable()
            
            // not a table, get cell
            if builder == nil {
                builder = section.builders[indexPath.row]
            }
            
            if let builder = builder {
                let cell = tableView.dequeueReusableCell(with: builder.getType(), for: indexPath)
                cell.selectionStyle = .none
                builder.callBuilder(path: indexPath, cell: cell)
                return cell
            } else {
                return UITableViewCell()
            }
            
        } else {
            buildTable()
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].viewBuilder?(section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].height
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = sections[indexPath.section]
        if let builder = section.getTable() {
            return builder.getHeight()
        } else {
            return section.builders[indexPath.row].getHeight()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = sections[indexPath.section]
        if let builder = section.getTable() {
            return builder.getHeight()
        } else {
            return section.builders[indexPath.row].getHeight()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let clicableCell = tableView.cellForRow(at: indexPath) as? LACustomDidSelectRowAt {
            clicableCell.didSelectRowAt(indexPath: indexPath)
        } else if let builder = self.builder(for: indexPath) {
            builder.didSelectRow(at: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = builder(for: indexPath)?.setupLeadingEdit(index: indexPath)
        return config ?? UISwipeActionsConfiguration(actions: [])
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = builder(for: indexPath)?.setupTrailingEdit(index: indexPath)
        return config ?? UISwipeActionsConfiguration(actions: [])
    }
}

