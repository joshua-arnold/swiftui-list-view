//
//  ContentView.swift
//  Demo
//
//  Created by Josh Arnold on 10/13/24.
//

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

#Preview {
    ContentView()
}
