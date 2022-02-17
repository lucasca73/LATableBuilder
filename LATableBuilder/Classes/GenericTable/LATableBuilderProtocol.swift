//
//  LATableBuilderProtocol.swift
//  LATableBuilder
//
//  Created by Lucas Costa Araujo on 29/11/21.
//

import UIKit

/// Protocol to be used as API to access the feature of a table builder without locking inheritance
public protocol LATableBuilderProtocol: UIViewController {
    var tableView: LATableBuilderView? { get }
}

extension LATableBuilderProtocol {
    
    private var table: LATableBuilderView {
        guard let table = tableView else { fatalError("Should implement tableView var") }
        return table
    }
    
    public func viewDidLoad(_ animated: Bool) {
        table.setupTableView()
    }
    
    public func viewDidDisappear(_ animated: Bool) {
        table.clearBuilders()
        table.reloadData()
    }
    
    public func setupTableView() {
        self.view.backgroundColor = .white
        self.view.addSubview(table)
        table.setAllConstraints(on: self.view)
        table.setupTableView()
    }
    
    public func clearBuilders() {
        table.sections.removeAll()
    }
    
    public func buildTable() {
        table.clearBuilders()
    }
    
    public func reload(_ ids: String...) {
        table.reload(ids)
    }
    
    public func addSection( title: String? = nil,
                     height: CGFloat = 0,
                     reloadListener: String? = nil,
                     _ builder: LASectionViewBuilder? = nil ) {
        table.addSection(title: title, height: height, reloadListener: reloadListener, builder)
    }
    
    @discardableResult public func add<T: UITableViewCell>(cell: T.Type,
                                                           height: CGFloat = UITableView.automaticDimension,
                                                           reloadListener: String? = nil,
                                                           builder: ((T) -> Void)? = nil ) -> LACellBuilder<T> {
        table.add(cell: T.self, height: height, reloadListener: reloadListener, builder: builder)
    }
    
    @discardableResult public func addTable<T: UITableViewCell>(cell: T.Type,
                                                         counter: @escaping (() -> Int),
                                                         reloadListener: String? = nil,
                                                         builder: ((IndexPath, T) -> Void)? = nil ) -> LATableBuilder<T> {
        table.addTable(cell: T.self, counter: counter, reloadListener: reloadListener, builder: builder)
    }
    
    @discardableResult public func addTable<T: UITableViewCell>(cell: T.Type,
                                                                count: Int,
                                                                rowHeight: CGFloat = UITableView.automaticDimension,
                                                                reloadListener: String? = nil,
                                                                builder: ((IndexPath, T) -> Void)? = nil ) -> LATableBuilder<T> {
        table.addTable(cell: T.self, count: count, rowHeight: rowHeight, reloadListener: reloadListener, builder: builder)
    }
    
    @discardableResult public func addTable<T: UITableViewCell>(cell: T.Type,
                                                                reloadListener: String? = nil) -> LATableBuilder<T> {
        table.addTable(cell: T.self, reloadListener: reloadListener)
    }
    
    public func removeSection(id: String, animation: UITableView.RowAnimation = .automatic) {
        table.removeSection(id: id, animation: animation)
    }
    
    public func insertNewSection(id: String, animation: UITableView.RowAnimation = .automatic) {
        table.insertNewSection(id: id, animation: animation)
    }
    
    public func builder(for indexPath: IndexPath) -> LABuilderProtocol? {
        table.builder(for: indexPath)
    }
}
