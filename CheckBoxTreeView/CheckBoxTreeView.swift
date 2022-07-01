//
//  CheckBoxTreeView.swift
//  CheckBoxTreeView
//
//  Created by 이창수 on 2022/07/01.
//

import SwiftUI

struct CheckBoxTreeView: View {
    private let nodes: [Node]
    
    @Binding var checked: Set<Node.ID>
    @State private var expanded: Set<Node.ID> = []
    
    init(nodes: [Node], selectedSet: Binding<Set<Node.ID>>) {
        self.nodes = nodes
        self._checked = selectedSet
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                CheckBoxTreeRow(nodes: nodes, depth: 0, checked: $checked, expanded: $expanded)
            }
        }
    }
}

private struct CheckBoxTreeRow: View {
    let nodes: [Node]
    let depth: Int
    
    @Binding var checked: Set<Node.ID>
    @Binding var expanded: Set<Node.ID>
    
    var body: some View {
        ForEach(nodes) { node in
            CheckBoxTreeNode(node: node, depth: depth, checked: $checked, expanded: $expanded)
            
            if let children = node.children, expanded.contains(node.id) {
                CheckBoxTreeRow(nodes: children, depth: depth + 1, checked: $checked, expanded: $expanded)
            }
        }
    }
}

private struct CheckBoxTreeNode: View {
    let node: Node
    let depth: Int
    
    @Binding var checked: Set<Node.ID>
    @Binding var expanded: Set<Node.ID>
    
    private var collapsedImage: some View {
        Image(systemName: "arrowtriangle.right.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundColor(.gray)
    }
    
    private var expandedImage: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundColor(.gray)
    }
    
    private var checkBoxSelectedImage: some View {
        Image(systemName: "checkmark.square")
    }
    
    private var checkBoxHalfImage: some View {
        Image(systemName: "minus.square")
    }
    
    private var checkBoxUnselectedImage: some View {
        Image(systemName: "square")
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<depth, id: \.self) { _ in
                NodeSpacerView()
            }
            
            ExpandToggleView()
            
            CheckBoxView()
            
            Text(node.label)
        }
    }
    
    private func NodeSpacerView() -> some View {
        expandedImage
            .opacity(0)
    }
    
    @ViewBuilder
    private func ExpandToggleView() -> some View {
        if let _ = node.children {
            if expanded.contains(node.id) {
                expandedImage
                    .onTapGesture {
                        onCollapse(node: node)
                    }
            } else {
                collapsedImage
                    .onTapGesture {
                        onExpand(node: node)
                    }
            }
        } else {
            NodeSpacerView()
        }
    }
    
    @ViewBuilder
    private func CheckBoxView() -> some View {
        if let children = node.children {
            if children.map({ $0.id }).reduce(true, { $0 && checked.contains($1) }) {
                checkBoxSelectedImage
                    .onTapGesture {
                        onUncheck(node: node)
                    }
                    .onAppear {
                        check(id: node.id)
                    }
            } else {
                if checked.intersection(node.childrenIDs).count > 0 {
                    checkBoxHalfImage
                        .onTapGesture {
                            onUncheck(node: node)
                        }
                        .onAppear {
                            uncheck(id: node.id)
                        }
                } else {
                    checkBoxUnselectedImage
                        .onTapGesture {
                            onCheck(node: node)
                        }
                        .onAppear {
                            uncheck(id: node.id)
                        }
                }
            }
        } else {
            if checked.contains(node.id) {
                checkBoxSelectedImage
                    .onTapGesture {
                        onUncheck(node: node)
                    }
                    .onAppear {
                        check(id: node.id)
                    }
            } else {
                checkBoxUnselectedImage
                    .onTapGesture {
                        onCheck(node: node)
                    }
                    .onAppear {
                        uncheck(id: node.id)
                    }
            }
        }
    }
    
    private func onExpand(node: Node) {
        expand(id: node.id)
    }
    
    private func expand(id: Node.ID) {
        expanded.insert(id)
    }
    
    private func onCollapse(node: Node) {
        collapse(id: node.id)
    }
    
    private func collapse(id: Node.ID) {
        expanded = expanded.filter { $0 != id }
    }
    
    private func onCheck(node: Node) {
        check(id: node.id)
        
        if let children = node.children {
            children.forEach { onCheck(node: $0) }
        }
    }
    
    private func check(id: Node.ID) {
        DispatchQueue.main.async {
            checked.insert(id)
        }
    }
    
    private func onUncheck(node: Node) {
        uncheck(id: node.id)
        
        if let children = node.children {
            children.forEach { onUncheck(node: $0) }
        }
    }
    
    private func uncheck(id: Node.ID) {
        DispatchQueue.main.async {
            checked = checked.filter { $0 != id }
        }
    }
}
