//
//  SwiftUIView.swift
//  common-ground-prod
//
//  Created by dan crowley on 6/12/24.
//

import SwiftUI
import SwiftfulUI

enum editableValue {
    case none, name, hometown, email, phone
}


struct UserSettingsView: View {
    @State private var offsetAmount: CGSize = CGSize(width: 200, height: 130)
    @State private var direction: CGFloat = -0.4 // Direction of movement
    @State private var opacity: CGFloat = 0.04
    @State private var expandedRow: String? = nil
    @State private var isVisible: Bool = true
    @State private var visibilityCity: String = "New York City"
    @State private var name: String = "Case Resor"
    @State private var hometown: String = "Jackson, WY"
    @State private var email: String = "cresor@doubleblacktrans.com"
    @State private var phoneNumber: String = "‭307 413 8040‬"
    @State private var valueVisible: Bool = true
    @State private var moveTitle: Bool = true
    @State private var isEditing: Bool = false
    @State private var selectedValue: editableValue = .none
    

    var body: some View {
        ZStack {
            Color.greybg
                .overlay(alignment: .bottom) {
                    Color.white
                        .frame(height: 66)
                }
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    if expandedRow == nil {
                        HStack {
                            Text("USER \nSETTINGS")
                                .font(.custom("HelveticaNeue", size: 24))
                                .bold()
                                
                            Spacer()
                        }
                        .opacity(0)
                        .padding(.bottom, 22)
                        HStack(spacing: 44) {
                            Text("User Settings")
                                .font(.custom("HelveticaNeue", size: 14))
                                .fontWeight(.bold)
                                
                                .offset(x: moveTitle ? 0 : -20 , y: moveTitle ? 0 : -20 )
                                .scaleEffect(moveTitle ? 1 : 1.3)
                            
                            Group {
                                Text("VALUE 1")
                                Text("VALUE 2")
                            }
                            .opacity(valueVisible ? 0.8 : 0)
                        }
                        .font(.custom("HelveticaNeue", size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 2)
                        
                        Rectangle()
                            .frame(height: 1.5)
                            
                            .opacity(0.7)
                            .offset(x: moveTitle ? 400 : 0)
                    }
                    Group {
                        SettingsRowView2(title: "About", expandedRow: $expandedRow, name: $name, hometown: $hometown, isEditing: $isEditing, selectedValue: $selectedValue)
                        VisibilitySettingsRow(title: "Visibility", expandedRow: $expandedRow, isVisible: $isVisible, visibilityCity: $visibilityCity)
                        ContactSettingsRow(title: "Contact", expandedRow: $expandedRow, email: $email, phoneNumber: $phoneNumber, selectedValue: $selectedValue, isEditing: $isEditing)
                    }
                    Spacer()
                }
                .padding()
                .offset(x: isEditing ? -400 : 0)
            }
            .padding(.horizontal, 16)
            
            VStack {
                switch selectedValue {
                case .none:
                    Image(systemName: "arrow.left")
                        .asButton {
                            isEditing = false
                        }
                case .name:
                    EditableTextField(text: $name, placeholder: name)
                case .hometown:
                    EditableTextField(text: $hometown, placeholder: hometown)
                case .email:
                    EditableTextField(text: $email, placeholder: email)
                case .phone:
                    EditableTextField(text: $phoneNumber, placeholder: phoneNumber)

                }
                
                Image(systemName: "arrow.left")
                    .asButton {
                        isEditing = false
                    }
            }
            .offset(x: !isEditing ? 400 : 0)
        }
        .foregroundColor(.black)
       
        .animation(.smooth, value: isEditing)
        .overlay(alignment: .topLeading) {
            Image("settingsBG2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .offset(offsetAmount)
                .allowsHitTesting(false)
                
        }
        .onAppear {
            startAnimationLoop()
            withAnimation(.smooth(duration: 4)) {
                valueVisible.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.smooth(duration: 2.2)) {
                    moveTitle = false
                }
            }
            
        }
        
    }
    
    func startAnimationLoop() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if offsetAmount.width > 850 {
                offsetAmount = CGSize(width: -200, height: 100)
                direction =  1
            } else if offsetAmount.width > -1800 {
                withAnimation(.linear(duration: 1.0)) {
                    offsetAmount.width += 20 * direction
                    offsetAmount.height += 6 * direction
                }
            } else {
                opacity = 0
                offsetAmount = CGSize(width: 200, height: 120)
                direction = -1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 0.1)) {
                        opacity = 0.04
                    }
                }
            }
        }
    }
}

struct SettingsRowView2: View {
    let title: String
    var arrow: Bool = true
    @Binding var expandedRow: String?
    @Binding var name: String
    @Binding var hometown: String
    @Binding var isEditing: Bool
    @Binding var selectedValue: editableValue

    var body: some View {
        VStack {
            HStack(spacing: 22) {
                Image(systemName: "arrow.right")
                    .opacity(arrow ? 1.0 : 0.0)
                    .rotationEffect(expandedRow == title ? Angle(degrees: 90) : Angle(degrees: 0))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            if expandedRow == title {
                                expandedRow = nil
                            } else {
                                expandedRow = title
                            }
                        }
                    }
                Text(title)
                    .font(.custom("HelveticaNeue-Bold", size: 16))
                Spacer()
              
                Group {
                    Text(name)
                    Text(hometown)
                }
                .font(.custom("HelveticaNeue", size: 12))
                .opacity(expandedRow == title ? 0 : 1)
            }
            .padding(.vertical, 4)
            if expandedRow == title {
                UserInfoSettingsChildView(title: "About", name: $name, hometown: $hometown, isEditing: $isEditing, selectedValue: $selectedValue)
                
                    
            }
                
            Rectangle()
                .frame(height: 2)
        
        }
    }
}

struct VisibilitySettingsRow: View {
    let title: String
    var arrow: Bool = true
    @Binding var expandedRow: String?
    @Binding var isVisible: Bool
    @Binding var visibilityCity: String
    
    

    var body: some View {
        VStack {
            HStack(spacing: 22) {
                Image(systemName: "arrow.right")
                    .opacity(arrow ? 1.0 : 0.0)
                    .rotationEffect(expandedRow == title ? Angle(degrees: 90) : Angle(degrees: 0))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            if expandedRow == title {
                                expandedRow = nil
                            } else {
                                expandedRow = title
                            }
                        }
                    }
                Text(title)
                    .font(.custom("HelveticaNeue-Bold", size: 16))
                Spacer()
              
                Group {
                    if isVisible {
                        HStack(spacing: 6) {
                            Image(systemName: "eye")
                                .font(.system(size: 14))
                            Text("in")
                        }
    
                    } else {
                        
                        HStack {
                            Image(systemName: "eye.slash")
                                .font(.system(size: 14))
                            Text("in")
                        }
                    }
                    
                    Text("\(visibilityCity)")
                }
                .font(.custom("HelveticaNeue", size: 12))
                .opacity(expandedRow == title ? 0 : 1)
            }
            .padding(.vertical, 4)
            if expandedRow == title {
                VisibilitySettingsChildView(title: "visibility", isVisible: $isVisible, visibilityCity: $visibilityCity)
                
                    
            }
                
            Rectangle()
                .frame(height: 2)
        
        }
    }
}
struct UserInfoSettingsChildView: View {
    @State private var currentTab: String = "name"
    var title: String
    @Binding var name: String
    @Binding var hometown: String
    @Binding var isEditing: Bool
    @Binding var selectedValue: editableValue
    
    var body: some View {
        ScrollViewWithOnScrollChanged(.horizontal, showsIndicators: false) {
            HStack(alignment: .top,spacing: 0) {
                VStack(alignment: .center, spacing: 32) {
                    Text(name)
                        
                    
                        
                }
              
                                .padding(.bottom, 54)
                .containerRelativeFrame(.horizontal)
                
                VStack(alignment: .center ) {
                    Text(hometown)
                        
                      
                }
//                .background(Color.blue.opacity(0.3))
              
                .containerRelativeFrame(.horizontal)
            }
            .onTapGesture {
                isEditing = true
                
            }
            .onDisappear {
                selectedValue = .name
            }

        } onScrollChanged: { origin in
            if origin.x > 100 {
                
                currentTab = "Name"
                selectedValue = .name
                 
            } else {
                currentTab = "Hometown"
                selectedValue = .hometown
            }
        }
            .padding(.top, 48)
            .font(.custom("HelveticaNeue-Bold", size: 33))
            .frame(maxWidth: .infinity, alignment: .center)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .overlay(alignment: currentTab == "Name" ? .center : .center) {
            Text(currentTab)
                .padding(.trailing, 4)
                .offset(y: 44)
                .font(.custom("HelveticaNeue-Bold", size: 12))
                .opacity(0.55)
                .textCase(.uppercase)
                
                
        }
//            .animation(.easeOut(duration: 2), value: currentTab)
    }
        
        
}

#Preview {
    UserSettingsView()
}



struct VisibilitySettingsChildView: View {
    var title: String
    @Binding var isVisible: Bool
    @Binding var visibilityCity: String
    @State private var currentTab: String = "Visible"
    
    
    var body: some View {
        ScrollViewWithOnScrollChanged(.horizontal, showsIndicators: false) {
            HStack(alignment: .top,spacing: 0) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    HStack(spacing: 24) {
                        Text("You are **visible**.")
                        Image(systemName: "eye")
                    }
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width / 1.6
                    }
                    
                    Text("Users will be able to see your card and interact with you. Your current location is set to **\(visibilityCity)**.")
                        .font(.custom("HelveticaNeue", size: 12))
                        .multilineTextAlignment(.center)
                        .containerRelativeFrame(.horizontal) { width, _ in
                            width / 1.6
                        }
                    
                }
                .containerRelativeFrame(.horizontal)
                           
                VStack(alignment: .leading, spacing: 24) {
                    
                    HStack(spacing: 24) {
                        Text("You are **hidden**.")
                        Image(systemName: "eye.slash")
                        
                    }
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width / 1.6
                    }
                    VStack(alignment: .center, spacing: 18) {
                        Text("Other users in **\(visibilityCity)** will not be able to see you.")
                        Text("swipe to toggle this setting.")
                    }
                    .multilineTextAlignment(.center)
                        .containerRelativeFrame(.horizontal) { width, _ in
                            width / 1.6
                        }
                        .font(.custom("HelveticaNeue", size: 12))
                }
                .containerRelativeFrame(.horizontal)
                
                    
                        
                
                
            }
            
            .padding(.vertical, 48)
            .font(.custom("HelveticaNeue", size: 33))
            .frame(maxWidth: .infinity, alignment: .center)

        } onScrollChanged: { origin in
            if origin.x > 250 {
                print(origin.x.description)
                print(isVisible.description)
                currentTab = "Visible"
                withAnimation {
                    isVisible = true
                }
                 
            } else {
                currentTab = "Hidden"
                print(isVisible.description)
                withAnimation {
                    isVisible = false
                }
            }
        }

        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .defaultScrollAnchor( isVisible ? .leading : .trailing)
        }
        
}

struct ContactSettingsRow: View {
    let title: String
    var arrow: Bool = true
    @Binding var expandedRow: String?
    @Binding var email: String
    @Binding var phoneNumber: String
    @State private var showPhoneNumber: Bool = false
    @State private var timer: Timer?
    @Binding var selectedValue: editableValue
    @Binding var isEditing: Bool
    
    var emailParts: (String, String) {
        let parts = email.split(separator: "@")
        return (String(parts.first ?? ""), String(parts.last ?? ""))
        
    }

    var body: some View {
        VStack {
            HStack(spacing: 22) {
                Image(systemName: "arrow.right")
                    .opacity(arrow ? 1.0 : 0.0)
                    .rotationEffect(expandedRow == title ? Angle(degrees: 90) : Angle(degrees: 0))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            if expandedRow == title {
                                expandedRow = nil
                            } else {
                                expandedRow = title
                            }
                        }
                    }
                Text(title)
                    .font(.custom("HelveticaNeue-Bold", size: 16))
                Spacer()
              
                VStack(alignment: .trailing, spacing: 16) {
                    
                        Text(phoneNumber)
                    
                    HStack(spacing: 3) {
                        Text(emailParts.0)
                        Text("@")
                            .font(.custom("HelveticaNeue-Bold", size: 16))
                        Text(emailParts.1)
                    }
                        
                    }
                .font(.custom("HelveticaNeue", size: 12))
                .opacity(expandedRow == title ? 0 : 1)
            }
            .padding(.vertical, 4)
            if expandedRow == title {
                ContactSettingsChildView(title: "Contact", email: $email, phoneNumber: $phoneNumber, selectedValue: $selectedValue, isEditing: $isEditing)
                
                    
            }
                
            Rectangle()
                .frame(height: 2)
        
        }
        .onAppear {
          
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            withAnimation(.smooth(duration: 3)) {
                showPhoneNumber.toggle()
            }
        })
    }
}

struct ContactSettingsChildView: View {
    var title: String
    @Binding var email: String
    @Binding var phoneNumber: String
    @Binding var selectedValue: editableValue
    @Binding var isEditing: Bool
    
    var emailParts: (String, String) {
        let parts = email.split(separator: "@")
        return (String(parts.first ?? ""), String(parts.last ?? ""))
        
    }
    var body: some View {
        ScrollViewWithOnScrollChanged(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .center , spacing: 12) {
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 12) {
                            Text(emailParts.0)
                            
                            Text("@")
                                .font(.custom("HelveticaNeue-Bold", size: 30))
                                .scaleEffect(y: 1.1)
                                .offset(x:0, y: 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                     
                    }
                    .containerRelativeFrame(.horizontal, { width, _ in
                        width / 1.33 })
                    Text(emailParts.1)
                        .font(.custom("HelveticaNeue-Bold", size: 10))
                }
                
                .padding(.bottom, 54)
                .textCase(.lowercase)
                .containerRelativeFrame(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(phoneNumber)
                      
                }
                .containerRelativeFrame(.horizontal)
            }
            .onTapGesture {
                isEditing = true
                
            }
            
            .padding(.top, 48)
            .font(.custom("HelveticaNeue-Bold", size: 24))
            .frame(maxWidth: .infinity, alignment: .center)
        } onScrollChanged: { origin in
            if origin.x > 270 {
                print(origin.x.description)
                
                
                
                    
                    selectedValue = .email
                
                 
            } else {
                    selectedValue = .phone
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Text(selectedValue == .email ? "email" : "phone number")
                .padding(.leading, 4)
                .font(.custom("HelveticaNeue-Bold", size: 12))
                .opacity(0.44)
                .offset(y: -15)
                .textCase(.uppercase)
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        }
}

#Preview {
    UserSettingsView()
}


struct EditableTextField: View {
    @Binding var text: String
    var placeholder: String = ""

    var body: some View {
        VStack(alignment: .center) {
            
            TextField(placeholder, text: $text)
                .font(.custom("HelveticaNeue-Bold", size: 55))
                .offset(y: -150)
                .padding(.horizontal, 44)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        EditableTextField(text: .constant("Case Resor"))
            
    }
  
}
