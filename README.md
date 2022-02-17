# LATableBuilder

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LATableBuilder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LATableBuilder'
```

## Hello world

```swift
import UIKit
import LATableBuilder

class ExampleViewController: LATableBuilderController {
    override func buildTable() {
        super.buildTable()
        add(cell: UITableViewCell.self) { cell in 
            cell.textLabel?.text = "Hello World"
        }
        reload()
    }
}
```

## Using a static list of cells
```swift
// Static list
addTable(cell: UITableViewCell.self, count: 3) { index, cell in 
    cell.textLabel?.text = "Hello World \(index.row)"
}

// Static list using a loop
// not recommended for large amounts of data
for i in dataArray {
    let dataObject = dataArray[i]
    add(cell: UITableViewCell.self) { [dataObject] cell in 
        cell.textLabel?.text = "Hello World"
    }
}
```
using `[dataObject]` will ensure that the block doesnt holds a strong reference of it

## Using a dynamic list of cell
```swift
let builder = addTable(cell: UITableViewCell.self, reloadListener: "key1")
builder.setupCounter { [dataArray] in dataArray.count }
builder.setupBuilder{ [dataArray] index, cell in
    let data = dataArray[index.row]
    cell.textLabel?.text = "\(data)"
}

// Using reload listener enables to reload the cells from that specific key
reload("key1")
```

## Creating native sections
```swift
// Simple as that :)
addSection(title: "As a System Section", height: 40)
```

## Creating custom sections
```swift
addSection(height: 50) { section in
    let customHeader = UIView()
    customHeader.backgroundColor = .systemBlue.withAlphaComponent(0.35)
    
    let label = UILabel(frame: CGRect(x: 24, y: 0, width: 200, height: 50))
    customHeader.addSubview(label)
    label.textColor = .white
    label.text = "Custom header view"
    
    return customHeader
}
```

## Using the TableBuilder as a Protocol
```swift
class ViewController: UIViewController, LATableBuilderProtocol {
    var tableView: LATableBuilderView? = LATableBuilderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildTable()
    }

    func buildTable() {
        clearBuilders()
        add(cell: UITableViewCell.self) { cell in 
            cell.textLabel?.text = "Hello World"
        }
        reload()
    }
}
```

## Updating the data
- `buildTable()` will erase past data and show all fresh and new. 
- `reload()` will reload all the data same as `reloadData()` from UITableView. Static lists using `count:` can break your code trying to access an index, to prevent that you need to have `counter:` defined.
- `reload("key1")` will reload only cells that have `"key1"` as a reloadListener.

## Author

Lucas Costa Araujo, lucascostaa73@gmail.com, lucasca73

## License

LATableBuilder is available under the MIT license. See the LICENSE file for more info.
