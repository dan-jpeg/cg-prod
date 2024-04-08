//
//  LogoHelpers.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/15/24.


import SwiftUI

struct LogoShape: Shape {
    
    
    var size: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = size
        
        //maintain logo aspect ratio
        let height = size * (70 / 110)
        path.addRect(CGRect(x: rect.midX-(width/2), y: rect.midY-(height/2), width: width, height: height))
        
        return path
    }
}

struct LogoShape2: Shape {
    
    let size: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()

        let width = size
        let offset = size * ( 40 / 110 )
        //maintain logo aspect ratio
        let height = size * (70 / 110)
        // Draw rectangle
       
        path.addRect(CGRect(x: rect.midX-(width/2), y: rect.midY-(height/2)+offset, width: width, height: height))
        return path
    }
}

