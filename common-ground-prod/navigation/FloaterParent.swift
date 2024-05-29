//
//  FloaterParent.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/19/24.
//

import SwiftUI

struct FloaterParent: View {
    var user: DBUser = .mock
    @State private var viewState: editSection = .notEditing
    @State private var phone1: String = "6305611337"
    @State private var phone2: String = "6305611337"
    @Namespace private var namespace
    
    @State private var scrollOffset = CGFloat.zero
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("common ground")
                Text("id: \(user.userId)")
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 72)
            
          

            VStack(alignment: .leading) {
                if viewState == .notEditing {
                    if let firstName = user.firstName, let lastName = user.surname {
                        HStack(spacing: 0) {
                           Text(firstName + " " + lastName)
                           Text("___ _ _")
                        }
                        .padding(.bottom, 12)
                        Group {
                            
                            CircleFillText(text: "6305611337", fill: true)
                                .overlay {
                                    Text("+2")
                                        .offset(x: -100)
                                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                                }
                                .matchedGeometryEffect(id: "phone1", in: namespace)
                            
                            CircleFillText(text: "6305611337", fill: false)
                                .overlay {
                                    Text("+1")
                                        .offset(x: -100)
                                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                                }
                                .matchedGeometryEffect(id: "phone2", in: namespace)
                        }

                    }
                    
                    Button(action: {
                        withAnimation {
                            viewState = .phoneNumber
                            
                        }
                        
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.black)
                    .opacity(0.8)
                    .offset(x: 120, y: 88)
                }
                if viewState == .phoneNumber {
                    VStack {
                        phoneEditView(namespace: namespace, primaryPhoneNumber: $phone1, secondaryPhoneNumber: $phone2)
                            .scaleEffect(1.5)
                            .padding(.bottom, 120)
                        phoneNumberEditSection(primaryPhoneNumber: $phone1, secondaryPhoneNumber: $phone2)
                    }
                    .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .onEnded({  value in
                            if value.translation.width < 0 {
                                withAnimation {
                                    viewState = .notEditing
                                }
                            }
                        }))
                  
                }
                
               
            }
            .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded({  value in
                    if value.translation.height < 0 {
                        withAnimation {
                            viewState = .phoneNumber
                        }
                    }
                }))
            .frame(maxHeight: .infinity, alignment: .top)
            
            .font(.system(size: 15))
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all)
            

        }
        .textCase(.uppercase)
        .font(.system(size: 11))
    }
}

struct phoneEditView: View {
    
    var namespace: Namespace.ID
    @Binding var primaryPhoneNumber: String
    @Binding var secondaryPhoneNumber: String
    
    var body: some View {
        VStack(spacing: 16) {
            CircleFillText(text: primaryPhoneNumber, fill: true)
                .overlay {
                    Text("+2")
                        .offset(x: -100)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                }
                .matchedGeometryEffect(id: "phone1", in: namespace)
            
            CircleFillText(text: secondaryPhoneNumber, fill: false)
                .overlay {
                    Text("+1")
                        .offset(x: -100)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                }
                .matchedGeometryEffect(id: "phone2", in: namespace)
                
        }
    }
}

struct phoneNumberEditSection: View {
    @Binding var primaryPhoneNumber: String
    @Binding var secondaryPhoneNumber: String
    
    var characterLimit: Int = 10
    
    var body: some View {
        VStack {
            TextField("Primary Phone Number", text: $primaryPhoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: primaryPhoneNumber) { _, newValue in
                    if primaryPhoneNumber.count > characterLimit {
                        primaryPhoneNumber = String(primaryPhoneNumber.prefix(characterLimit))
                    }
                }
            
            TextField("Secondary Phone Number", text: $secondaryPhoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
        .padding(.top, 20)
    }
}

struct hometownEditSection: View {
    
    @Binding var hometown: String
    var characterLimit: Int = 16
    var body: some View {
        VStack {
            TextField("hometown", text: $hometown)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: hometown) { _, newValue in
                    if hometown.count > characterLimit {
                        hometown = String(hometown.prefix(characterLimit))
                    }
                }
        }
        .padding(.top, 20)
    }
}





#Preview {
    FloaterParent()
}
