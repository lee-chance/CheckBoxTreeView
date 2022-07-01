//
//  CheckBoxTreeNode.swift
//  CheckBoxTreeView
//
//  Created by 이창수 on 2022/07/01.
//

import Foundation

struct Node: Identifiable {
    typealias ID = String
    let id: ID
    let label: String
    let children: [Node]?
    
    init(id: ID = UUID().uuidString, label: String, children: [Node]? = nil) {
        self.id = id
        self.label = label
        self.children = children
    }
    
    init(_ label: String, children: [Node]? = nil) {
        self.id = label
        self.label = label
        self.children = children
    }
    
    var childrenIDs: Set<ID> {
        getChildrenID(node: self)
    }
    
    private func getChildrenID(node: Node) -> Set<ID> {
        var temp = Set([node.id])
        
        if let children = node.children {
            let childrenIDs = children.reduce(Set<ID>()) { $0.union(getChildrenID(node: $1)) }
            temp = temp.union(childrenIDs)
        }
        
        return temp
    }
}
