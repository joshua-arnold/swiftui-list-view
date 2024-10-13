//
//  ListView.swift
//  Demo
//
//  Created by Josh Arnold on 10/13/24.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - ListView

@available(iOS 16.0, *)
public struct ListView<Content: View>: View {
    
    private let content: () -> Content
    private let configure: (UITableView) -> Void
    
    /// Create a `ListView`, a `SwiftUI.View` that wraps `UITableView`
    /// - Parameters:
    ///   - content: The content to render in a list. Uses variadic views to create different cells.
    ///   - configure: Optionally configure the properties on the `UITableView`.
    public init(
        @ViewBuilder _ content: @escaping () -> Content,
        configure: @escaping (UITableView) -> Void = { _ in }
    ) {
        self.content = content
        self.configure = configure
    }
    
    public var body: some View {
        _VariadicView.Tree(listView, content: content)
    }
    
    private var listView: some _VariadicView_UnaryViewRoot {
        UnaryViewRoot { views in
            ListViewRepresentable(
                views: views.map {
                    CellModel(id: $0.id, view: AnyView($0))
                },
                configure: configure
            )
        }
    }
}

// MARK: - Views

public typealias Views = _VariadicView.Children

// MARK: - UnaryViewRoot

fileprivate struct UnaryViewRoot<Content: View>: _VariadicView_UnaryViewRoot {
    let views: (Views) -> Content

    func body(children: Views) -> some View {
        views(children)
    }
}

// MARK: - CellModel

struct CellModel: Hashable {
    let id: AnyHashable
    let view: AnyView
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - ListViewRepresentable

@available(iOS 16.0, *)
struct ListViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UITableView
    
    let views: [CellModel]
    let configure: (UITableView) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIViewType {
        let tableView = UITableView()
        context.coordinator.updateDataSourceIfNecessary(with: tableView)
        tableView.delegate = context.coordinator
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Coordinator.reuseIdentifier)
        return tableView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        configure(uiView)
        context.coordinator.reloadData(views: views)
    }
}

// MARK: - Coordinator

extension ListViewRepresentable {
        
    final class Coordinator: NSObject, UITableViewDelegate {
        static let reuseIdentifier = "list-view-cell"
        static let mainSection: Int = 0
        
        private var dataSource: UITableViewDiffableDataSource<Int, CellModel>?
        
        func updateDataSourceIfNecessary(with tableView: UITableView) {
            self.dataSource = UITableViewDiffableDataSource<Int, CellModel>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, CellModel: CellModel) -> UITableViewCell? in

                let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)

                cell.contentConfiguration = UIHostingConfiguration {
                    CellModel.view
                }

                return cell
            }
        }
        
        func reloadData(views: [CellModel]) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, CellModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(views, toSection: Self.mainSection)
            dataSource?.apply(snapshot)
        }
    }
}
