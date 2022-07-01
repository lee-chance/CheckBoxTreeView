//
//  ContentView.swift
//  CheckBoxTreeView
//
//  Created by 이창수 on 2022/07/01.
//

import SwiftUI

struct ContentView: View {
    @State private var checked: Set<Node.ID> = []
    
    private let continents: [Node] = [
        Node("아프로-유라시아", children: [
            Node("아프리카"),
            Node("유라시아", children: [
                Node("유럽"),
                Node("아시아")
            ]),
        ]),
        Node("오스트레일리아", children: [
            Node("오세아니아")
        ]),
        Node("아메리카", children: [
            Node("북아메리카", children: [
                Node("북아메리카"),
                Node("중앙아메리카"),
                Node("카리브")
            ]),
            Node("남아메리카")
        ]),
        Node("남극")
    ]
    
    var body: some View {
        VStack {
            CheckBoxTreeView(nodes: continents, selectedSet: $checked)

            Text("\(String(describing: checked))")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
