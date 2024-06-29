//
//  Resources.swift
//  ToDoApp
//
//  Created by Dmitriy Kalyakin on 28.06.2024.
//

import SwiftUI

enum Resources {
    enum Colors {
        enum Support {
            static let separator = Color("SupportSeparator")
            static let overlay = Color("SupportOverlay")
            static let navBarBlur = Color("SupportNavBarBlur")
        }
        
        enum Label {
            static let primary = Color("LabelPrimary")
            static let secondary = Color("LabelSecondary")
            static let tertiary = Color("LabelTertiary")
            static let disable = Color("LabelDisable")
        }
        
        enum Back {
            static let primary = Color("BackPrimary")
            static let IOSprimary = Color("BackIOSPrimary")
            static let secondary = Color("BackSecondary")
            static let elevated = Color("BackElevated")
        }
        
        static let red = Color("Red")
        static let green = Color("Green")
        static let blue = Color("Blue")
        static let gray = Color("Gray")
        static let grayLight = Color("GrayLight")
        static let white = Color("White")
    }
}
