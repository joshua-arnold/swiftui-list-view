# `ListView`

A `SwiftUI` wrapper around `UITableView`.

### Summary

`ListView` uses `UIViewRepresentable` to wrap UIKit's `UITableView` in a SwiftUI view.

It uses the private (but apparently stable) API for SwiftUI variadic views so that we can automatically split up the ListView content into multiple reusable, high performance cells.

### Why?

`List` in SwiftUI is extremely opaque and often missing functionality from its UIKit elder, UITableView.

In addition, `List` seems to have unexpected behavior with animations and transitions in SwiftUI.

By using a custom implementation, `ListView`, we can gain finer control of our UI.

### Usage

```swift
import SwiftUI

struct ContentView: View {

    var body: some View {
        ListView {
            ForEach(0..<1000) { id in
                Text(String(describing: id))
            }
        } configure: { tableView in
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
        }
    }
}
```

### Interesting reading

Here are some blog posts & repos I used when writing `ListView`.

**ViewExtractor library**
This is an interesting library that shows how to interact with variadic views.

- https://github.com/GeorgeElsham/ViewExtractor/tree/main

**A few articles on variadic views**

Here are a few articles that go into some depth on variadic views, which are a pretty interesting (and private) API.

- https://movingparts.io/variadic-views-in-swiftui
- https://chris.eidhof.nl/post/variadic-views/
- https://www.emergetools.com/blog/posts/how-to-use-variadic-view
