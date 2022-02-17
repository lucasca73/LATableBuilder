import UIKit

public class LATableBuilder<T>: LABuilderProtocol where T: UITableViewCell {
    
    public typealias BuildTable = ((IndexPath, T) -> Void)
    public typealias SetupEdit = ((IndexPath) -> UISwipeActionsConfiguration?)
    public typealias Counter = (() -> Int)
    public typealias DidSelected = ((IndexPath) -> Void)
    
    public var builder: BuildTable?
    public var rows: Int = 1
    public var type: T.Type
    public var counter: Counter?
    public var cellId: String?
    public var rowHeight: CGFloat = UITableView.automaticDimension
    public var leadingEdit: SetupEdit?
    public var trailingEdit: SetupEdit?
    public var didSelectRow: DidSelected?
    
    public init(type: T.Type, builder: BuildTable?, cellId: String?) {
        self.builder = builder
        self.type = type
        self.cellId = cellId
    }
    
    public func callBuilder(path: IndexPath, cell: UITableViewCell) {
        // swiftlint:disable:next force_cast
        builder?(path, cell as! T)
    }
    
    public func getType<U>() -> U.Type where U: UITableViewCell {
        // swiftlint:disable:next force_cast
        return type as! U.Type
    }
    
    public func setupBuilder(_ builder: BuildTable?) {
        self.builder = builder
    }
    
    public func setupCounter(_ counter: Counter?) {
        self.counter = counter
    }
    
    public func setupDidSelect(_ didSelect: DidSelected?) {
        self.didSelectRow = didSelect
    }
    
    public func getCount() -> Int {
        if let counter = counter {
            return counter()
        }
        return rows
    }
    
    public func isTable() -> Bool {
        return true
    }
    
    public func shouldReload(id: String) -> Bool {
        return cellId?.contains(id) ?? false
    }
    
    public func getHeight() -> CGFloat {
        return rowHeight
    }
    
    public func setupLeadingEdit(index: IndexPath) -> UISwipeActionsConfiguration? {
        leadingEdit?(index)
    }
    
    public func setupTrailingEdit(index: IndexPath) -> UISwipeActionsConfiguration? {
        trailingEdit?(index)
    }
    
    public func didSelectRow(at index: IndexPath) {
        didSelectRow?(index)
    }
}
