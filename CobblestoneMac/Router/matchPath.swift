//
//  getPathComponents.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/25/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.
//

import Foundation

func getPathComponents(_ pathStr: String) -> [String] {
    let parts = pathStr.components(separatedBy: "/")
    return parts
}

func matchPath(template: String, pathStr: String) -> [String: String]? {
    let templateParts = getPathComponents(template.lowercased())
    let pathParts = getPathComponents(pathStr.lowercased())
    if (pathParts.count != templateParts.count) {
        return nil
    }

    var params = [String: String]()
    
    for i in 0 ..< templateParts.count {
        let templatePart = templateParts[i]
        let pathPart = pathParts[i]
        
        if templatePart != pathPart {
            if !templatePart.hasPrefix(":") {
                return nil
            }
            let propName = String(templatePart.dropFirst(1))
            if (propName.count > 0) {
                params[propName] = pathPart
            }
        }
    }
    
    return params
}
