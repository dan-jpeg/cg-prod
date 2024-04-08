//
//  common_ground_prodApp.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/14/24.
//

import SwiftUI
import Firebase
import SwiftfulRouting



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("app delegate run")
    return true
  }
}


@main
struct commonGroundProdApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                ContentView()
                
            }
            
        }
    }
}

