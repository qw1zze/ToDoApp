//
//  Color+extensions.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 29.06.2024.
//

import SwiftUI

extension Color {
    func getHex() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 0]
        return String(format: "#%02lX%02lX%02lX%02lX",
                              lroundf(Float(components[0] * 255)),
                              lroundf(Float(components[1] * 255)),
                              lroundf(Float(components[2] * 255)),
                              lroundf(Float(components[3] * 255)))
    }
}
