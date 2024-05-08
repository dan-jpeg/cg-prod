//
//  ColorTheme.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/19/24.
//

import SwiftUI

protocol ColorThemeProtocol {
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}

struct GreenColorTheme: ColorThemeProtocol {
    let primary: Color = .commonGreen
    let secondary: Color = .commonGreenBG
    let tertiary: Color = .gray
}

struct BlueColorTheme: ColorThemeProtocol {
    let primary: Color = .commonBlue
    let secondary: Color = .commonBlueBG
    let tertiary: Color = .gray
}

struct RedColorTheme: ColorThemeProtocol {
    let primary: Color = .commonRed
    let secondary: Color = .commonRedBG
    let tertiary: Color = .gray
}


