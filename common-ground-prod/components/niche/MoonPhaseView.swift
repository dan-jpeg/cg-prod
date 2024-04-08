//
//  MoonPhaseView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/21/24.
//

import SwiftUI

struct MoonPhaseView: View {
    let moonPhases = "🌕🌖🌗🌘🌑🌒🌓🌔".map { String($0) }
    
    var body: some View {
        PhaseAnimator(moonPhases) { phase in
            Text(phase).id(phase)
        } animation: { _ in
          .easeInOut(duration: 1.0)
        }
        .font(.system(size: 24))
    }
}

#Preview {
    MoonPhaseView()
}

//CustomTextField(icon: "none", placeHolder: "EM", text: $viewModel.email)
//    .textInputAutocapitalization(.never)
//    .padding()
//
//Divider()
//CustomTextField(icon: "none", placeHolder: "PW", text: $viewModel.password)
