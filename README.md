# LATableBuilder

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LATableBuilder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LATableBuilder'
```

## Basic usage

```swift
override func buildTable() {

    // Erase past builders to prepare new implementation
    super.buildTable()

    // Adding a single cell
    add(cell: TextTableViewCell.self) { cell in 
        cell.configure(with: someData)
    }

    // Adding a serie of cells
    addTable(cell: TextTableViewCell.self, count: someDataArray.count) { index, cell in 
        let data = someDataArray[index.row]
        cell.configure(with: data)
    }

    // Will call reloadData, insert, delete checking current changes
    reload()
}
```

## Author

Lucas Costa Araujo, lucascostaa73@gmail.com, lucasca73

## License

LATableBuilder is available under the MIT license. See the LICENSE file for more info.
